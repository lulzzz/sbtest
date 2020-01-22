<xsl:stylesheet version="1.0" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="urn:my-scripts" xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:fn="http://exslt.org/math">
  <xsl:param name="selectedYear"/>
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="/">
		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office"
					xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
					xmlns:html="http://www.w3.org/TR/REC-html40">
			<WindowHeight>7005</WindowHeight>
			<WindowWidth>19200</WindowWidth>
			<WindowTopX>0</WindowTopX>
			<WindowTopY>0</WindowTopY>
			<ActiveSheet>1</ActiveSheet>
			<ProtectStructure>False</ProtectStructure>
			<ProtectWindows>False</ProtectWindows>
      <Styles>
        <Style ss:ID="Default" ss:Name="Normal">
          <Alignment ss:Vertical="Bottom"/>
          <Borders/>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
          <Interior/>
          <NumberFormat/>
          <Protection/>
        </Style>
        <Style ss:ID="s63">
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s64">
          <Interior/>
        </Style>
        <Style ss:ID="s65">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
        </Style>
        <Style ss:ID="s66">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s67">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"/>
        </Style>
        <Style ss:ID="s68">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
        </Style>
        <Style ss:ID="s69">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s70">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"/>
        </Style>
        <Style ss:ID="s71">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="#,##0.00;\-#,##0.00"/>
        </Style>
        <Style ss:ID="s72">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="#,##0.00;\-#,##0.00"/>
        </Style>
        <Style ss:ID="s73">
          <NumberFormat ss:Format="#,##0.00;\-#,##0.00"/>
        </Style>
        <Style ss:ID="s74">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s75">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="@"/>
        </Style>
      </Styles>
			<xsl:apply-templates />

		</Workbook>
  </xsl:template>
	<xsl:template match="ExtractResponse">
		<Worksheet ss:Name="1095C Information">
			<Table x:FullColumns="1" x:FullRows="1">
        <Column ss:Index="2" ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="58.5"/>
        <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="62.25"/>
        <Column ss:AutoFitWidth="0" ss:Width="62.25" ss:Span="2"/>
        <Column ss:Index="7" ss:AutoFitWidth="0" ss:Width="125.25"/>
        <Column ss:AutoFitWidth="0" ss:Width="99.75"/>
        <Column ss:AutoFitWidth="0" ss:Width="75"/>
        <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="68.25" ss:Span="2"/>
        <Column ss:Index="13" ss:AutoFitWidth="0" ss:Width="66"/>
        <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="60"/>
        <Column ss:AutoFitWidth="0" ss:Width="55.5"/>
        <Column ss:AutoFitWidth="0" ss:Width="54.75"/>
        <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="62.25"/>
        <Column ss:Index="20" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="57"/>
        <Column ss:Index="22" ss:StyleID="s63" ss:Width="52.5"/>
        <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:Index="25" ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="57.75"/>
        <Column ss:Index="29" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:Index="32" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:Index="35" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:Index="38" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:Index="40" ss:AutoFitWidth="0" ss:Width="52.5"/>
        <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="62.25"/>
        <Column ss:AutoFitWidth="0" ss:Width="57"/>
        <Column ss:Index="44" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:Index="47" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:Index="50" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Column ss:Index="52" ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="57"/>
        <Column ss:Index="56" ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="55.5"/>
        <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="46.5"/>
        <Row ss:AutoFitHeight="0" ss:Height="66">
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Year and Type of Form (YYYYT) Type = B or C</Data>
          </Cell>
          <Cell ss:StyleID="s66">
            <Data ss:Type="String">Employee SSN</Data>
          </Cell>
          <Cell ss:StyleID="s66">
            <Data ss:Type="String">Employee Birth Date (Required if SSN is missing)</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">First Name of Employee</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Middle Name of Employee</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Last Name of Employee</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Street Address</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">City</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">State (2 Character Abbreviation)</Data>
          </Cell>
          <Cell ss:StyleID="s66">
            <Data ss:Type="String">Zip Code (5 or 9 with no dash)</Data>
          </Cell>
          <Cell ss:StyleID="s66">
            <Data ss:Type="String">Record Status</Data>
          </Cell>
          <Cell ss:StyleID="s66">
            <Data ss:Type="String">Plan Starting Month (01-12)</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">Employee Offer of Coverage</Data>
          </Cell>
          <Cell ss:StyleID="s71">
            <Data ss:Type="String">Employee Share</Data>
          </Cell>
          <Cell ss:StyleID="s65">
            <Data ss:Type="String">4980H if applicable</Data>
          </Cell>
          <Cell ss:StyleID="s74">
            <Data ss:Type="String">SSN of Covered Individual 1</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s74">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s74">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">SSN of Covered Individual</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">First Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Middle Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Last Name</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">Birth Date</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s67">
            <Data ss:Type="String">December</Data>
          </Cell>
        </Row>
        <Row>
          <Cell>
            <Data ss:Type="String">R</Data>
          </Cell>
          <Cell ss:StyleID="s69">
            <Data ss:Type="String">R</Data>
          </Cell>
          <Cell ss:StyleID="s69">
            <Data ss:Type="String"> </Data>
          </Cell>
          <Cell ss:StyleID="s68"/>
          <Cell ss:StyleID="s68"/>
          <Cell ss:StyleID="s68"/>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">R</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">R</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">R</Data>
          </Cell>
          <Cell ss:StyleID="s69">
            <Data ss:Type="String">R</Data>
          </Cell>
          <Cell ss:StyleID="s69"/>
          <Cell ss:StyleID="s69"/>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">All 12 Months</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">January</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">February</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">March</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">April</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">May</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">June</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">July</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">August</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">September</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">October</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">November</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s72">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s68">
            <Data ss:Type="String">December</Data>
          </Cell>
          <Cell ss:StyleID="s75">
            <Data ss:Type="Number">1</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s75"/>
          <Cell ss:StyleID="s75"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">2</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">3</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">4</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">5</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">6</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">7</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">8</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">9</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">10</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70">
            <Data ss:Type="Number">11</Data>
          </Cell>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
          <Cell ss:StyleID="s70"/>
        </Row>
				<xsl:apply-templates select="Hosts/ExtractHost/Companies/ExtractCompany/EmployeeAccumulationList/Accumulation">
					<xsl:sort select="FirstName"/>
				</xsl:apply-templates>

			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<PageSetup>
					<Header x:Margin="0.3"/>
					<Footer x:Margin="0.3"/>
					<PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
				</PageSetup>
				<Print>
					<ValidPrinterInfo/>
					<HorizontalResolution>600</HorizontalResolution>
					<VerticalResolution>600</VerticalResolution>
				</Print>
				<Selected/>
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>5</ActiveRow>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		
		</Worksheet>
		
	</xsl:template>
	<xsl:template match="Accumulation">
		
		<Row>
			<Cell>
				<Data ss:Type="String"><xsl:value-of select="$selectedYear"/>C</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="SSNVal"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="BirthDateString"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s64">
				<Data ss:Type="String">
					<xsl:value-of select="FirstName"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s64">
				<Data ss:Type="String">
					<xsl:value-of select="MiddleInitial"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s64">
				<Data ss:Type="String">
					<xsl:value-of select="LastName"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s64">
				<Data ss:Type="String">
					<xsl:value-of select="translate(Contact/Address/AddressLine1,$smallcase,$uppercase)"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s64">
				<Data ss:Type="String">
					<xsl:value-of select="translate(Contact/Address/City,$smallcase,$uppercase)"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s64">
				<Data ss:Type="String">CA</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="Contact/Address/Zip"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">Original</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">01</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="C1095Line14All"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="C1095Line15All"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="C1095Line16All"/>
				</Data>
			</Cell>
			<xsl:apply-templates select="C1095Months/C1095Month">
				<xsl:sort select="Month" data-type="number"/>
			</xsl:apply-templates>
			
		</Row>

	</xsl:template>
	<xsl:template match="C1095Month">
		<xsl:choose>
			<xsl:when test="../../C1095Line14All=''">
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="Code14"/>
					</Data>
				</Cell>
			</xsl:when>
			<xsl:otherwise>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="''"/>
					</Data>
				</Cell>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="../../C1095Line15All=''">
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="Value"/>
					</Data>
				</Cell>
			</xsl:when>
			<xsl:otherwise>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="''"/>
					</Data>
				</Cell>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="../../C1095Line16All=''">
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="Code16"/>
					</Data>
				</Cell>
			</xsl:when>
			<xsl:otherwise>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="''"/>
					</Data>
				</Cell>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
                                                                                                    
