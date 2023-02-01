# 人工無能2020サンプルプログラム
# プロダクションルール（if-thenルール）がベース
# 辞書等のファイルはTSV形式（タブ区切りのテキストファイル）
# 　※元データはExcelで管理
# 　※Excelの内容をテキストエディタにコピー＆ペーストすると，列の区切りがタブになる（逆も同じ）
# 文字コード：UTF-8

use strict;
use Encode;


# 人工無能の名前
my $chatterbot_name = "島原みんのすけ";

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
while(!&Chec_End_of_Dialogue()){
	# ユーザの発話（メッセージ）を取得
	# &Get_Users_Utterance();
	my @timetable1 = (
		['今治', '友浦', '木浦', '岩城', '佐島', '弓削', '生名', '土生'],
		['6:25', '6:45', '7:00', '7:12', '7:19', '7:25', '7:30', '7:35'],
		['7:50', '8:10', '8:25', '8:38', '8:45', '8:52', '8:58', '9:05'],
		['9:50', '10:10', '10:30', '10:43', '10:50', '10:57', '11:03', '11:10'],
		['12:40', '13:00', '13:20', '13:33', '13:40', '13:47', '13:53', '14:00'],
		['14:40', '15:00', '15:20', '15:33', '15:40', '16:10', '16:15', '16:20'],
		['17:25', '17:45', '18:00', '18:13', '18:20', '18:27', '18:33', '18:40'],
		['18:40', '19:00', '19:15', '19:28', '19:35', '19:42', '19:48', '19:55']
	);
	my @timetable2 = (
		['土生', '生名', '弓削', '佐島', '岩城', '木浦', '友浦', '今治'],
		['6:30', '6:35', '6:40', '6:46', '6:53', '7:05', '7:20', '7:40'],
		['7:40', '7:45', '7:50', '7:56', '8:03', '8:15', '8:30', '8:50'],
		['10:10', '10:17', '10:23', '10:30', '10:37', '10:50', '11:10', '11:30'],
		['12:50', '12:57', '13:03', '13:10', '13:17', '13:30', '13:50', '14:10'],
		['16:00', '16:07', '16:13', '16:20', '16:27', '16:40', '17:00', '17:20'],
		['17:10', '17:17', '17:23', '17:30', '17:37', '17:50', '18:10', '18:30'],
		['18:45', '18:50', '18:55', '19:01', '19:08', '19:20', '19:40', '20:00']
	);
	# Define a hash that maps port names to indices in the timetable
	my %port_indices1;
	for my $i (0..$#timetable1) {
		for my $j (0..$#{$timetable1[$i]}) {
			$port_indices1{$timetable1[$i][$j]} = $j;
		}
	}

	my %port_indices2;
	for my $i (0..$#timetable2) {
		for my $j (0..$#{$timetable2[$i]}) {
			$port_indices2{$timetable2[$i][$j]} = $j;
		}
	}
	# 対話の終わりのチェック
	# if( &Chec_End_of_Dialogue() ){
	# 	# 人工無能の発話を出力
	# 	print "$chatterbot_name > $chatterbots_utterance\n";

	# 	# 人工無能の発話に対応する合成音声を再生する
	# 	&Play_Synthetic_Speech();

	# 	print "--- $user_name と $chatterbot_name の対話終了 ---\n";
	# 	last;
	# }
	# Ask for the current port and destination port
	# print "$chatterbot_name > 今、どこ～？（例：今治港、友浦港、木浦港、岩城港、佐島港、弓削港、生名港、土生港)\n$user_name > ";
	START_POINT:
	Ask_current();

	# 人工無能の発話を出力
	print "$chatterbot_name > $chatterbots_utterance\n ";
	&Play_Synthetic_Speech();
	&Get_Users_Utterance();
	my $current_port = $users_utterance;
	chomp $current_port;

	# print "$chatterbot_name > 行きたい場所を教えてほしいゾ。（例：今治港、友浦港、木浦港、岩城港、佐島港、弓削港、生名港、土生港）\n$user_name > ";
	Ask_togo();

	# 人工無能の発話を出力
	print "$chatterbot_name > $chatterbots_utterance\n";
	&Play_Synthetic_Speech();
	&Get_Users_Utterance();
	my $destination_port = $users_utterance;
	chomp $destination_port;
	# Determine which direction the user is going based on the current and destination ports
	my $direction;
	if (exists $port_indices1{$current_port} && exists $port_indices1{$destination_port}) {
		if ($port_indices1{$current_port} < $port_indices1{$destination_port}) {
			$direction = 1;
			#print($direction);
		} else {
			$direction = 2;
			#print($direction);
		}
	}
	if (!defined $direction) {
		# print "$chatterbot_name > オラ、その場所は知らないゾ～ \n";
		Dont_know();
		print "$chatterbot_name > $chatterbots_utterance\n";
		&Play_Synthetic_Speech();
		goto START_POINT;
	}
	# Ask for the time the user wants to ride the ferry
	$chatterbots_utterance = "何時に行きたいんだ？（例：〇時に行きたい）";
	print "$chatterbot_name > $chatterbots_utterance\n";
	&Play_Synthetic_Speech();
	&Get_Users_Utterance();
	my $requested_time = $users_utterance;
	chomp $requested_time;

	# Check the timetable and find the nearest departure time
	my $departure_time;
	my $arrival_time;
	if ($direction == 1) {
		($departure_time, $arrival_time) = find_nearest_departure_time(\@timetable1, $port_indices1{$current_port}, $port_indices1{$destination_port}, $requested_time);
	} elsif ($direction == 2) {
		($departure_time, $arrival_time) = find_nearest_departure_time(\@timetable2, $port_indices2{$current_port}, $port_indices2{$destination_port}, $requested_time);
	}

	# Print the departure and arrival times
	print "$chatterbot_name > $departure_time に出て、\n";
	$chatterbots_utterance = $departure_time;
	&Play_Synthetic_Speech();
	$chatterbots_utterance = "に出て";
	&Play_Synthetic_Speech();
	print "$arrival_time に $destination_port に着く、 快速線があるゾ。\n";
	$chatterbots_utterance = $arrival_time;
	&Play_Synthetic_Speech();
	$chatterbots_utterance = $destination_port;
	&Play_Synthetic_Speech();
	$chatterbots_utterance = "に着く、 快速線があるゾ。";
	&Play_Synthetic_Speech();
	print "この船でいいか〜い？それとも他のにする〜？（良かったら、「ありがとう」もう一度聞く場合は、「他ので」）\n";
	&Get_Users_Utterance();
}

Convo_end();
print "$chatterbot_name > $chatterbots_utterance\n";

# 人工無能の発話に対応する合成音声を再生する
&Play_Synthetic_Speech();

print "--- $user_name と $chatterbot_name の対話終了 ---\n";

exit;





#################### ここからサブルーチン ####################

# Find the nearest departure time in the given timetable
sub find_nearest_departure_time {
    my ($timetable, $current_port_index, $destination_port_index, $requested_time) = @_;

    # Convert the requested time to minutes
    my ($requested_hour, $requested_minute) = split /:/, $requested_time;
    my $requested_time_minutes = ($requested_hour * 60) + $requested_minute;

    # Find the nearest departure time
    my $nearest_departure_time;
    my $nearest_arrival_time;
    my $min_diff = 24 * 60; # Initialize the minimum difference to a large value
    for my $i (1..$#$timetable) {
        # Convert the departure time to minutes
        my ($departure_hour, $departure_minute) = split /:/, $timetable->[$i][$current_port_index];
        my $departure_time_minutes = ($departure_hour * 60) + $departure_minute;

        # Calculate the difference between the requested time and the departure time
        my $diff = $departure_time_minutes - $requested_time_minutes;
        if ($diff < 0) {
            $diff += 24 * 60; # Add one day's worth of minutes if the difference is negative
        }

        # If the difference is smaller than the current minimum difference, update the nearest departure time and arrival time
        if ($diff < $min_diff) {
            $min_diff = $diff;
            $nearest_departure_time = $timetable->[$i][$current_port_index];
            $nearest_arrival_time = $timetable->[$i][$destination_port_index];
        }
    }

    return ($nearest_departure_time, $nearest_arrival_time);
}
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
		print "キミの名前を教えてほしいゾ > ";
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

sub Ask_current{
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


	open(IN, "ask-current.txt") or die $!;
	
	
	
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

sub Convo_end{
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


	open(IN, "convo-end.txt") or die $!;
	
	
	
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

sub Ask_togo{
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


	open(IN, "ask-togo.txt") or die $!;
	
	
	
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

sub Dont_know{
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


	open(IN, "dont-know.txt") or die $!;
	
	
	
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
	#system("open -a QuickTimePlayer $synthesized_speech_file");
	system("afplay $synthesized_speech_file");

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
