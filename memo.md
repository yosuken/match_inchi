
## reference: InChI_TechMan.pdf, Appendix 3

* http://www.inchi-trust.org/fileadmin/user_upload/software/inchi-v1.04/InChI_TechMan.pdf
	* [formula]/(chqpbtms/i(hbtms)/f((hqbtms/i(hbtms)o))/r(....))
	* This gem checks just the first "chqpbtms".

* FAQ: Comparing InChIs
	* http://www.inchi-trust.org/fileadmin/user_upload/html/inchifaq/inchi-faq.html#12


## match flags (130411 ver)

* [1] そのまま
* [2] 有機化合物から電荷を取り除く(/p, /q)

以下、有機化合物は[2]を、それ以外は[1]を比較の元とします。

* [3] /t の ? をマッチさせる (+ tの情報がない部位もマッチ)
* [4] /m0 と /m1 の比較の場合、/t の[+, -]をひっくり返す (引用文中の(b)などの例)
* [5] 片方の/m, /sを取り除いたものとマッチさせる
* [6] 片方の/t, /m, /s を取り除いたものとマッチさせる
