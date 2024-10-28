(:26:)
(:for $k in doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/swiat.xml')/SWIAT/KONTYNENTY/KONTYNENT:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:27:)
(:for $k in doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:28:)
(:for $k in doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA, 'A')]:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:29:)
(:for $k in doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[substring(NAZWA, 1, 1) = substring(STOLICA, 1, 1)]:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:30:)
(:doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/swiat.xml')//KRAJ:)

(:31:)
(:doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/zesp_prac.xml'):)

(:32:)
(:doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/zesp_prac.xml')//NAZWISKO:)

(:33:)
(:doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/zesp_prac.xml')//ROW[NAZWA='SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW/NAZWISKO:)

(:34:)
(:count(doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP=10]/PRACOWNICY/ROW):)

(:35:)
(:doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/zesp_prac.xml')//ROW[ID_SZEFA='100']/NAZWISKO:)

(:36:)
let $k := doc('file:///C:/Users/hanna/Desktop/2st/S2/ZTPD/lab/ZTPD/XPath-XSLT/zesp_prac.xml')//ZESPOLY/ROW/PRACOWNICY/ROW[ID_ZESP = /ZESPOLY/ROW/PRACOWNICY/ROW[NAZWISKO = 'BRZEZINSKI']/ID_ZESP]
return sum($k/PLACA_POD)