# 人工無能2020サンプルプログラム
# プロダクションルール（if-thenルール）がベース
# 辞書等のファイルはTSV形式（タブ区切りのテキストファイル）
# 　※元データはExcelで管理
# 　※Excelの内容をテキストエディタにコピー＆ペーストすると，列の区切りがタブになる（逆も同じ）
# 文字コード：UTF-8

use strict;
use Encode;


# 人工無能の名前
my $chatterbot_name = "test";

# 人工無能の発話用
my $chatterbots_utterance;

# ユーザの名前を取得する
my $user_name;
&Get_User_Name();

# 人工無能の発話用
my $users_utterance;



print "--- $user_name と $chatterbot_name の対話開始 ---\n";

# 人工無能の発話を選択する（対話の開始時用）
Select_Catterbot_Utterence1();

# 人工無能の発話を出力
print "$chatterbot_name > $chatterbots_utterance\n";

# 人工無能の発話に対応する合成音声を再生する
&Play_Synthetic_Speech();



# 無限ループ
while(1){
	# ユーザの発話（メッセージ）を取得
	&Get_Users_Utterance();

	# 対話の終わりのチェック
	if( &Chec_End_of_Dialogue() ){
		# 人工無能の発話を出力
		print "$chatterbot_name > $chatterbots_utterance\n";

		# 人工無能の発話に対応する合成音声を再生する
		&Play_Synthetic_Speech();

		print "--- $user_name と $chatterbot_name の対話終了 ---\n";
		last;
	}

	# 人工無能の発話を選択する（対話中用）
	Select_Catterbot_Utterence2();

	# 人工無能の発話を出力
	print "$chatterbot_name > $chatterbots_utterance\n";

	# 人工無能の発話に対応する合成音声を再生する
	&Play_Synthetic_Speech();

}







exit;





#################### ここからサブルーチン ####################


########################################
# @list中に$strが含まれていれば，そのインデックスを返す．
# そうでなければ，-1を返す．
sub include{
	my ($str, @list) = @_;

	for( my $i=0; $i<@list; $i++){
		if( $str eq $list[$i]){
			return $i;
		}
	}
	return -1;
}



########################################
# ユーザの名前を取得する
# 何らかの入力があるまで標準入力を繰り返す
sub Get_User_Name{
	my $stdin;
	while(1){
		print "あなたの名前を入力してください > ";
		$stdin = <STDIN>;
		$stdin =~ s/\n|\r\n|\r//;
		if( $stdin ne "" ){
			last;
		}
	}
	$user_name = $stdin;
}



########################################
# 人工無能の発話を選択する（対話の開始時用）
# プロダクションルール（if-thenルール）がベース
sub Select_Catterbot_Utterence1{
	my $line;
	my @list;

	# 辞書の内容を格納する
	# @candidateと@weightのインデックスは対応する
	# 人工無能の発話の候補
	my @candidate;
	# 重みの累積
	my @weight;
	# 重みの合計
	my $total = 0;

	# 辞書の読み込み
	my $i = 0;
	open(IN, "dic1.txt") or die $!;
	flock(IN, 1);
	while(<IN>){
		# 先頭から1行ずつ順番に$lineに格納
		$line = $_;

		# 先頭に「#」が付いてたらコメントなので，以降のループ内の処理をスキップする
		if( $line =~ /^#/ ){
			next;
		}

		# 文末の改行コードを削除
		$line =~ s/\n|\r\n|\r//;

		# タブ（\t）で分割
		@list = split("\t", $line);

		# 重みの合計を計算
		$total += $list[1];

		$candidate[$i] = $list[0];
		$weight[$i] = $total;
		$i++;
	}
	close(IN);


	# 出力する発話を選択する
	# ルーレット方式で選ぶ
	# 0～$totalまでの乱数を発生
	my $rand = rand($total);
	for( $i=0; $i<@candidate; $i++){
		if( $rand < $weight[$i] ){
			# print "$candidate[$i]\t$weight[$i]\n";
			$chatterbots_utterance = $candidate[$i];
			last;
		}
	}
}



########################################
# 人工無能の発話に対応する合成音声のファイルパスを取得する
# 人工無能の発話は，$chatterbots_utteranceに保持されている
sub Get_Synthesized_Speech_File{
	my $line;
	my @list;

	# 人工無能の発話の合成音声（ファイルパス）
	my $path = "./voice_data/";

	# 音声ファイルリストの読み込み
	open(IN, "./voice_data/filelist.txt") or die $!;
	flock(IN, 1);
	while(<IN>){
		# 先頭から1行ずつ順番に$lineに格納
		$line = $_;

		# 先頭に「#」が付いてたらコメントなので，以降のループ内の処理をスキップする
		if( $line =~ /^#/ ){
			next;
		}

		# 文末の改行コードを削除
		$line =~ s/\n|\r\n|\r//;

		# タブ（\t）で分割
		@list = split("\t", $line);

		if( $chatterbots_utterance eq $list[0]){
			$path .= $list[1];
			last;
		}
	}
	close(IN);
	return $path;
}



########################################
# 人工無能の発話に対応する合成音声を再生する
sub Play_Synthetic_Speech(){
	# 人工無能の発話に対応する合成音声のファイルパスを取得する
	# 人工無能の発話の合成音声（ファイルパス）
	my $synthesized_speech_file = Get_Synthesized_Speech_File();

	# 音声ファイルが存在しない場合，再生させない
	unless( -f $synthesized_speech_file ){
		print "\t※対応する音声ファイルがありません．\n";
		return;
	}

	# デフォルトのサウンドプレイヤーを起動して，音声を再生
	# バックグラウンドで起動したままになってしまうので注意する
	#system("cmd $synthesized_speech_file");
	# Windows用
	system("start $synthesized_speech_file");
}



########################################
# ユーザの発話（メッセージ）を取得
# 標準入力の内容を$users_utteranceに格納する
sub Get_Users_Utterance{
	print "$user_name > ";
	$users_utterance = <STDIN>;
	# 文末の改行コードを削除
	$users_utterance =~ s/\n|\r\n|\r//;
}



########################################
# 対話の終わりのチェック
# 辞書に対話処理終了のキーワードが登録されているかどうか
# 戻り値1：対話を終わる
# 戻り値0：対話を続ける
sub Chec_End_of_Dialogue{
	my $line;
	my @list;

	# 辞書の内容を格納する
	# @candidateと@weightのインデックスは対応する
	# 人工無能の発話の候補
	my @candidate;
	# 重みの累積
	my @weight;
	# 重みの合計
	my $total = 0;

	# 辞書の読み込み
	my $i = 0;
	open(IN, "dic3.txt") or die $!;
	flock(IN, 1);
	while(<IN>){
		# 先頭から1行ずつ順番に$lineに格納
		$line = $_;

		# 先頭に「#」が付いてたらコメントなので，以降のループ内の処理をスキップする
		if( $line =~ /^#/ ){
			next;
		}

		# 文末の改行コードを削除
		$line =~ s/\n|\r\n|\r//;

		# タブ（\t）で分割
		@list = split("\t", $line);

		# UTF8から内部文字列に変換（開発環境がUTF8のとき）
		# encode（元に戻す関数）は不要（$list[0]の使用はチェックだけなので）
		my $tmp = decode('UTF-8', $list[0]);
		my $decoded_users_utterance = decode('UTF-8', $users_utterance);

		if( $users_utterance eq $list[0] ){ # 完全一致（文字列比較演算子eqを使用）
		#if( index($decoded_users_utterance, $tmp) != -1){ # 部分一致（index関数を使用）
			# 重みの合計を計算
			$total += $list[2];

			$candidate[$i] = $list[1];
			$weight[$i] = $total;
			$i++;
		}
	}
	close(IN);

	# 対話を終了するキーワードが存在しない
	# ⇒重みの合計が0
	# ⇒対話を続ける
	if( $total == 0 ){
		return 0;
	}

	# 出力する発話（対話終了時の発話）を選択する
	# ルーレット方式で選ぶ
	# 0～$totalまでの乱数を発生
	my $rand = rand($total);
	for( $i=0; $i<@candidate; $i++){
		if( $rand < $weight[$i] ){
			# print "$candidate[$i]\t$weight[$i]\n";
			$chatterbots_utterance = $candidate[$i];
			last;
		}
	}
	return 1;
}



########################################
# 人工無能の発話を選択する（対話中用）
sub Select_Catterbot_Utterence2{
	my $line;
	my @list;

	# 辞書の内容を格納する
	# @candidateと@weightのインデックスは対応する
	# 人工無能の発話の候補
	my @candidate;
	# 重みの累積
	my @weight;
	# 重みの合計
	my $total = 0;

	# 辞書の読み込み
	my $i = 0;
	open(IN, "dic2.txt") or die $!;
	flock(IN, 1);
	while(<IN>){
		# 先頭から1行ずつ順番に$lineに格納
		$line = $_;

		# 先頭に「#」が付いてたらコメントなので，以降のループ内の処理をスキップする
		if( $line =~ /^#/ ){
			next;
		}

		# 文末の改行コードを削除
		$line =~ s/\n|\r\n|\r//;

		# タブ（\t）で分割
		@list = split("\t", $line);

		# UTF8から内部文字列に変換（開発環境がUTF8のとき）
		# encode（元に戻す関数）は不要（$list[0]の使用はチェックだけなので）
		my $tmp = decode('UTF-8', $list[0]);
		my $decoded_users_utterance = decode('UTF-8', $users_utterance);

		if( $users_utterance eq $list[0] ){ # 完全一致（文字列比較演算子eqを使用）
		#if( index($decoded_users_utterance, $tmp) != -1){ # 部分一致（index関数を使用）
			# 重みの合計を計算
			$total += $list[2];

			$candidate[$i] = $list[1];
			$weight[$i] = $total;
			$i++;
		}
	}
	close(IN);

	# ユーザが入力すべきキーワードが辞書中に存在しない
	# ⇒重みの合計が0
	# ⇒エラーメッセージを出力して対話を続ける
	if( $total == 0 ){
		# エラーメッセージの例
		$chatterbots_utterance = "別のメッセージを入力してください．";
		return;
	}


	# 出力する発話（対話終了時の発話）を選択する
	# ルーレット方式で選ぶ
	# 0～$totalまでの乱数を発生
	my $rand = rand($total);
	for( $i=0; $i<@candidate; $i++){
		if( $rand < $weight[$i] ){
			# print "$candidate[$i]\t$weight[$i]\n";
			$chatterbots_utterance = $candidate[$i];
			last;
		}
	}
}




__END__
