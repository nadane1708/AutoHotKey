/*
-----------------------Script Info-----------------------
Tested Windows Version: 10.0.17763.253 Enterprise LTSC (x64) (a.k.a Windows 10 Enterprise LTSC (x64))
Tested Autohotkey Version: 1.1.30.01 Unicode 32-bit
First Release Date : 2017/01/03
Last Modified : 2017/07/08
Version: 20170103
Author: Sean (nadane1708) - MusicBot is another my nickname.
---------------------------------------------------------
*/

/*
Alsong Lyric Parser
by MusicBot
*/

;Enviroments
;-------------------------------------
#NoEnv
#SingleInstance force
SetBatchLines, -1
ListLines, Off
#KeyHistory 0
Process, Priority,, High
;-------------------------------------

;Version
;-------------------------------------
Version = 20170103
;-------------------------------------

;Script
;-------------------------------------
Gui, Add, Edit, x22 y60 w140 h30 vTitle, 타이틀
Gui, Add, Edit, x182 y60 w140 h30 vArtist, 아티스트
Gui, Add, Text, x22 y40 w80 h20 , Title
Gui, Add, Text, x182 y40 w80 h20 , Artist
Gui, Add, Button, x342 y50 w100 h60 gSearch, 검색
Gui, Add, Text, x32 y130 w290 h30 +Center vIs_Searched,
Gui, Add, Button, x32 y170 w400 h30 gShowLyric, 가사보기
Gui, Add, CheckBox, x342 y130 w100 h30 vAutoLyric, 자동 가사 보기
; Generated using SmartGUI Creator 4.0
Gui, Show, x127 y87 h222 w472, 알송 가사 파서

Return


Search:
Gui, Submit, NoHide

GuiControl, , Is_Searched, 검색중..

; Thanks to frontjang for information about Alsong lyrics server: https://frontjang.tistory.com/199
String = <?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope" xmlns:SOAP-ENC="http://www.w3.org/2003/05/soap-encoding" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="ALSongWebServer/Service1Soap" xmlns:ns1="ALSongWebServer" xmlns:ns3="ALSongWebServer/Service1Soap12"><SOAP-ENV:Body><ns1:GetResembleLyric2><ns1:stQuery><ns1:strTitle>%Title%</ns1:strTitle><ns1:strArtistName>%Artist%</ns1:strArtistName><ns1:nCurPage>0</ns1:nCurPage></ns1:stQuery></ns1:GetResembleLyric2></SOAP-ENV:Body></SOAP-ENV:Envelope>

ComObjError(false)
WinHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WinHttp.Open("POST", "http://lyrics.alsong.co.kr/alsongwebservice/service1.asmx")
WinHttp.SetRequestHeader("Content-Type", "application/soap+xml; charset=utf-8")
WinHttp.Send(String)
WinHttp.WaitForResponse()

J := WinHttp.ResponseText

IfNotInString, J, ST_GET_RESEMBLELYRIC2_RETURN
{
	MsgBox , 48, Error, 검색 실패..
	GuiControl, , Is_Searched,
	J := ""
	
	Return
}

RegExMatch(J, "<strLyric>(.*?)</strLyric>", JJ)
StringReplace, JJ1, JJ1, &lt;br, , All
StringReplace, JJ1, JJ1, `;, , All
StringReplace, JJ1, JJ1, &gt, `n, All
StringReplace, JJ1, JJ1, ], ]%A_Space%, All

GuiControl, , Is_Searched, 검색 완료!

If(AutoLyric == 1)
	goto ShowLyric

Return


ShowLyric:

Gui, 2:Destroy

If(J = "")
{
	MsgBox, 48, Error, 검색된 가사가 없습니다.
	Return
}

Gui, 2:Add, Edit, x22 y20 w440 h460 ReadOnly +Center vLyric_Window,
Gui, 2:Add, Text, x22 y480 w440 h30 +Center, Lyrics From Alsong
Gui, 2:Add, Button, x22 y520 w440 h30 gSaveLyric, 가사 저장
Gui, 2:Show, x122 y87 h558 w484, Lyric

GuiControl, 2:, Lyric_Window, %JJ1%

Return


SaveLyric:

FileSelectFile, FileName, S24, , 저장,
If(ErrorLevel == 1)
	Return

IfExist, %FileName%
	FileDelete, %FileName%

FileAppend, %JJ1%, %FileName%, UTF-8

Return


GuiClose:
ExitApp
 
;-------------------------------------