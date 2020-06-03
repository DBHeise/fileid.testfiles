[CmdletBinding()] 
param(
	[String]$FileIdExe,
	[Switch]$ShowAll
)


Set-Alias -Name fileid -Value (Resolve-Path -Path ($FileIdExe) -ErrorAction Stop)

Write-Verbose -Message ("Using FileId executable: " + (Get-Alias fileid).Definition )

function TestExcelFormulas {
param(
	[String] $file,
	[String[]] $macroTexts
)
	$filename = (gci $file)[0].FullName
	Write-Verbose -Message ("Testing File: " + $filename)	
	$data = fileid $filename json | ConvertFrom-Json
	$formulas = $data.extensions.sheets.Records | ? {$_.Type -eq 'Formula' }
	$size = $macroTexts.length
	0..($size - 1) | % {
		$expected = $macroTexts[$_]
		$actual = $formulas[$_].FormulaString
		if ($expected -eq $actual) {
			if ($ShowAll) {
				Write-Host ("PASS: '"+ $expected +"'='" + $actual +"'")
			} else {
				Write-Verbose ("PASS: '"+ $expected +"'='" + $actual +"'")
			}
		} else {
			Write-Error -Category InvalidResult -message ("FAIL: '"+ $expected +"'!='" + $actual +"'")
		}
	}

}



TestExcelFormulas ".\xls\Excel.Tests\Formulas\basic1.xls" @(
	"PtgAttrSemi;PtgFunc(NOW)",                                                 #NOW()
	"PtgAttrSemi;PtgFunc(RAND)",                                                #RAND()
	"PtgAttrSemi;PtgNameX(RANDBETWEEN);PtgNum(-5.000000);PtgInt(5);PtgFuncVar(User Defined Function)", #RANDBETWEEN(-5,5)
	"PtgRef(C3);PtgFunc(YEAR)",                                                 #YEAR(C3)
	"PtgRef3d(C4);PtgFunc(COS)",                                                #COS(Sheet1!C4)
	"PtgName(_xlfn.CEILING.MATH);PtgRef(B2);PtgInt(100);PtgMul;PtgFuncVar(User Defined Function)",#CEILING.MATH(B2*100)
	"PtgRef(B3);PtgFuncVar(ROMAN)",                                             #ROMAN(B3)
	"PtgRef(B3);PtgFunc(LN)",                                                   #LN(B3)
	"PtgArea(B2:B5);PtgAttrSum",                                                #SUM(B2:B5)
	"PtgNameX(DEC2HEX);PtgRef(B3);PtgFuncVar(User Defined Function)",           #DEC2HEX(B3)
	"PtgNameX(HEX2BIN);PtgRef(B7);PtgFuncVar(User Defined Function)",           #HEX2BIN(B7)
	"PtgRef(B3);PtgInt(2);PtgFunc(POWER)"                                       #POWER(B3,2)
	)

TestExcelFormulas ".\xls\Excel.Tests\Formulas\strings.xls" @(
	"PtgRef(A20);PtgRef(A8);PtgRef(A9);PtgRef(A19);PtgRef(A30);PtgRef(A9);PtgRef(A19);PtgRef(A30);PtgRef(A1);PtgRef(A30);PtgRef(A20);PtgRef(A5);PtgRef(A19);PtgRef(A20);PtgRef(A29);PtgFuncVar(CONCATENATE)",
	"PtgRef(A8);PtgRef(A20);PtgRef(A20);PtgRef(A16);PtgRef(A27);PtgRef(A28);PtgRef(A28);PtgRef(A20);PtgRef(A5);PtgRef(A19);PtgRef(A20);PtgRef(A31);PtgRef(A8);PtgRef(A5);PtgRef(A9);PtgRef(A19);PtgRef(A5);PtgRef(A9);PtgRef(A14);PtgRef(A11);PtgRef(A31);PtgRef(A3);PtgRef(A15);PtgRef(A13);PtgFuncVar(CONCATENATE)",
	"PtgName(_xlfn.WEBSERVICE);PtgRef(B5);PtgFuncVar(User Defined Function)",
    "PtgRef(B5);PtgRef(A20);PtgRef(A5);PtgRef(A19);PtgRef(A20);PtgRef(A31);PtgFuncVar(CONCATENATE);PtgStr(`"`")",
	"PtgName(_xlfn.WEBSERVICE);PtgRef(B7);PtgFuncVar(User Defined Function)",
	"PtgStr(`" `")"
)
TestExcelFormulas ".\xls\Excel.Tests\Excel4Macros\Book1.BIFF8.backup.xls" @(
	"PtgStr(`"calc.exe`")",
	"PtgFuncVar(HALT)"
)

#C:\dev.public\fileid.testfiles\xls\Excel.Tests\Excel4Macros\Book1.BIFF8.xls
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\Excel4Macros\getworkspace_values.xls
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\Excel4Macros\RealLikeSample.xls
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\Excel4Macros\Sneeky.xls
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\passwords\test_nopwd.xls
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\passwords\test_pwd2openis_test.xls
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\passwords\test_pwd2openis_test_pwd2m
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\DataConnection.xls
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\DataConnection_full.xls
#C:\dev.public\fileid.testfiles\xls\Excel.Tests\KitchenSink.xls"