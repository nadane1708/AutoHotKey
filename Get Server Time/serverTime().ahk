/*
-----------------------Script Info-----------------------
Tested Window Version: 6.1.7601 (x64) (a.k.a Window 7 (x64))
Tested Autohotkey Version: 1.1.29.01 Unicode 64-bit
Date : 2018/05/13 KST
Last Modified : 2018/07/01 KST
Author: BOTLoi (a.k.a MusicBot)
---------------------------------------------------------
*/

/*
; Example

MsgBox % serverTime("http://www.naver.com/", sday, 9)
MsgBox % sday
return
*/

serverTime(serverURL, ByRef s_day, localTime := 0)
{
	tick := A_TickCount
	req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	req.open("GET", serverURL, false)
	req.Send()
	req.WaitForResponse()

	header := req.getAllResponseHeaders()	
	RegExMatch(header, "Date:\s\w{3}."
						. "\s(\d{2})\s" ; ���� �ð� (��)
						. "(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s" ; ���� �ð� (��)
						. "(\d{4})\s" ; ���� �ð� (����)
						. "(\d{2}).(\d{2}).(\d{2})\s" ; ���� �ð� (��, ��, ��)
						. "GMT", w)
	if !(w1) ; HTTP Header���� �ð� ���� Ȯ�� �Ұ���
		return, -1 ; ���� �ڵ� -1 ��ȯ

	s_year := w3, s_month := w2, s_date := w1, s_hour := w4, s_minute := w5, s_second := w6
	tick := A_TickCount - tick
	
	s_time := s_year
					. ( (s_month = "Jan") ? "01" : (s_month = "Feb") ? "02" : (s_month = "Mar") ? "03" : (s_month = "Apr") ? "04" : (s_month = "May") ? "05" : (s_month = "Jun") ? "06" : (s_month = "Jul") ? "06" : (s_month = "Aug") ? "07" : (s_month = "Sep") ? "09" : (s_month = "Oct") ? "10" : (s_month = "Nov") ? "11" : "12" )
					. s_date
					. s_hour
					. s_minute
					. s_second
	
	/*
	stime -= Floor(tick/1000) ; ���� �ð� ����
	*/
	
	s_time += localTime, Hours ; ǥ�� �ð��� ���� (GMT �ð� ����)
	
	FormatTime, s_day, %s_time% L0x0409, ddd ; ���� �ð� (����)

	return, s_time
}