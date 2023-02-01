# chatbot
人口無能課題

弓削周辺のフェリーの時刻表を教えてくれるチャットボットアシスタント。

辞書：

# Google Sheets: 

https://docs.google.com/spreadsheets/d/1wYq4lKjx_REt2sYf9ic6L2bCV_UalAIup2UDFmaHXkA/edit#gid=0


# Google Docs: 

Response1:

https://docs.google.com/document/d/1nfwhjom3lzJMCXvBaAjHNsdfIaSUCcKX7iOnL_Uiqrg/edit

Response2:

https://docs.google.com/document/d/1FPf-pS7xf8L0doebwCTPgMxLsSo7ubbqz34OcsMhrx4/edit


Response3:

https://docs.google.com/document/d/1q4JSFgRN4nvXks54ZUvv-jjno8zXS0hwYK8ZE3VJceU/edit


Response4:

https://docs.google.com/document/d/18WL3OFSBRP0y2w6Nqa0hIJIHSDftfOnWSfK81F_Oqn4/edit

# 構成図:
![chatbot_plot drawio (1)](https://user-images.githubusercontent.com/72961603/202326699-5495f5fd-af7a-491d-8c5f-a56c45e11483.png)



https://app.diagrams.net/#Hchinggisod%2Fchatbot%2Fmain%2Fchatbot_plot.drawio

**Response1:** 挨拶                                 **Question1:** ユーザーの＜名前＞ ?      **UserInput1:** ＜名前＞


**Response2:** ＜名前＞に対応                        **Question2:** ＜乗り場＞           **UserInput2:** ＜乗り場＞ 


**Response3:** ＜乗り場＞に対応                     **Question3:** ＜行き先＞?               **UserInput3:** ＜行き先＞


**Response4:** ＜行き先＞に対応                       **Question4:** ＜乗る時間＞？       **UserInput4:** ＜乗る時間＞


**Response5a:** ＜乗る時間＞に合った時間と情報を伝う    **Question5:** ころでよろしい？もう一度確認する？ **UserInput5:** Yes Or No
  
  
**Response5b:** ＜乗る時間＞は時間外ためもう一度入力お願い
  
  
**Response6:** おしゃべりありがとう
