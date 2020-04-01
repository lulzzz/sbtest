<xsl:stylesheet version="1.0"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:msxsl="urn:schemas-microsoft-com:xslt"
 xmlns:user="urn:my-scripts"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" >

	<xsl:param name="selectedYear"/>
	<xsl:param name="endQuarterMonth"/>
  <xsl:param name="quarter"/>
  <xsl:param name="todaydate"/>
  <xsl:param name="startdate"/>
  <xsl:param name="enddate"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:template match="/">
		
		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
		  
	<WindowHeight>7035</WindowHeight>
	<WindowWidth>19200</WindowWidth>
	<WindowTopX>0</WindowTopX>
	<WindowTopY>0</WindowTopY>
  <ActiveSheet>2</ActiveSheet>
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
        <Style ss:ID="s53" ss:Name="Hyperlink">
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#0563C1"
           ss:Underline="Single"/>
        </Style>
        <Style ss:ID="s63">
          <NumberFormat ss:Format="Short Date"/>
        </Style>
        <Style ss:ID="s64">
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s65">
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
        </Style>
        <Style ss:ID="s67">
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
        <Style ss:ID="s68">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="Fixed"/>
        </Style>
        <Style ss:ID="s69">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="Fixed"/>
        </Style>
        <Style ss:ID="s70">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
        </Style>
        <Style ss:ID="s71">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s72">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <NumberFormat ss:Format="Fixed"/>
        </Style>
        <Style ss:ID="s73">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s74">
          <NumberFormat ss:Format="#,##0.00;\-#,##0.00"/>
        </Style>
        <Style ss:ID="s76">
          <NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
        </Style>
        <Style ss:ID="s77">
          <Borders/>
          <Interior/>
          <NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
        </Style>
        <Style ss:ID="s78">
          <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
          <NumberFormat ss:Format="0"/>
        </Style>
        <Style ss:ID="s79">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s80">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <Interior/>
        </Style>
        <Style ss:ID="s81">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <Interior/>
        </Style>
        <Style ss:ID="s82">
          <Interior/>
        </Style>
        <Style ss:ID="s83">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Interior/>
        </Style>
        <Style ss:ID="s84">
          <Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s85">
          <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30"
           ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s86">
          <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30"
           ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss"/>
          <NumberFormat ss:Format="00000"/>
        </Style>
        <Style ss:ID="s87">
          <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30"
           ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="00000"/>
        </Style>
        <Style ss:ID="s88">
          <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30"
           ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss"/>
          <NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
        </Style>
        <Style ss:ID="s89">
          <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30"
           ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
        </Style>
        <Style ss:ID="s90">
          <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s91">
          <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss"/>
          <NumberFormat ss:Format="0"/>
        </Style>
        <Style ss:ID="s92">
          <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s93">
          <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss"/>
          <NumberFormat ss:Format="00000"/>
        </Style>
        <Style ss:ID="s94">
          <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss"/>
          <NumberFormat ss:Format="#,##0.00;\-#,##0.00"/>
        </Style>
        <Style ss:ID="s95">
          <Alignment ss:Vertical="Center" ss:Rotate="31" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
        </Style>
        <Style ss:ID="s96">
          <Alignment ss:Vertical="Center" ss:Rotate="31"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"/>
        </Style>
        <Style ss:ID="s97">
          <Alignment ss:Vertical="Center" ss:Rotate="31"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"/>
          <NumberFormat ss:Format="&quot;$&quot;#,##0.00"/>
        </Style>
        <Style ss:ID="s98">
          <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
        </Style>
        <Style ss:ID="s99">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s100">
          <NumberFormat ss:Format="&quot;$&quot;#,##0.00"/>
        </Style>
        <Style ss:ID="s101">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s102">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <NumberFormat ss:Format="&quot;$&quot;#,##0.00"/>
        </Style>
        <Style ss:ID="s103">
          <NumberFormat ss:Format="0"/>
        </Style>
      </Styles>
			<xsl:apply-templates/>
		</Workbook>
	</xsl:template>


	<xsl:template match="ExtractResponse">
	
		<Worksheet ss:Name="QEX 2020 Company Information">
            <Table >
							 <Column ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="58.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="113.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="112.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="125.25"/>
   <Column ss:StyleID="s82" ss:AutoFitWidth="0" ss:Width="114"/>
   <Column ss:AutoFitWidth="0" ss:Width="99.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="75"/>
   <Column ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="68.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="104.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="78"/>
   <Column ss:Index="14" ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:Index="17" ss:AutoFitWidth="0" ss:Width="72.75"/>
   <Column ss:Index="19" ss:StyleID="s64" ss:Width="52.5"/>
   <Column ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="46.5"/>
   <Column ss:Index="22" ss:StyleID="s82" ss:AutoFitWidth="0" ss:Width="46.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="57.75"/>
   <Row ss:AutoFitHeight="0" ss:Height="66">
    <Cell ss:StyleID="s66"><Data ss:Type="String">EIN </Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Name Control</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Business Name 1</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Business Name 2</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Address 1</Data></Cell>
    <Cell ss:StyleID="s80"><Data ss:Type="String">Country Code - (US or Blank for Domestic)</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">City</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">State</Data></Cell>
    <Cell ss:StyleID="s67"><Data ss:Type="String">Zip Code</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Preparer / Agent Name</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Preparer / Agent Title</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Company Contact Name</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Company Contact Title</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Phone Number</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">e-Mail Address</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Signature Name</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Signature Date</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Account Type</Data></Cell>
    <Cell ss:StyleID="s67"><Data ss:Type="String">Routing Number</Data></Cell>
    <Cell ss:StyleID="s84"><Data ss:Type="String">Account Number</Data></Cell>
    <Cell ss:StyleID="s69"><Data ss:Type="String">Online PIN ( For Indirect Filers Only)</Data></Cell>
    <Cell ss:StyleID="s80"><Data ss:Type="String">Address Change - Not Necessary for V2.1 and later</Data></Cell>
    <Cell ss:StyleID="s70"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s81"/>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s71"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">R</Data></Cell>
    <Cell ss:StyleID="s72"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s79"/>
    <Cell ss:StyleID="s79"/>
    <Cell ss:StyleID="s73"/>
    <Cell ss:StyleID="s83"/>
   </Row>
   
            
   <Row></Row>
							<xsl:apply-templates select="Hosts/ExtractHost" mode="CompanyInfo">
								<xsl:sort select="HostCompany/TaxFilingName"/>
							</xsl:apply-templates>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
                <PageSetup>
                    <Header x:Margin="0.3" />
                    <Footer x:Margin="0.3" />
                    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75" />
                </PageSetup>
                <Print>
                    <ValidPrinterInfo/>
                    <HorizontalResolution>600</HorizontalResolution>
                    <VerticalResolution>600</VerticalResolution>
                </Print>
                <Selected/>
                <ProtectObjects>False</ProtectObjects>
                <ProtectScenarios>False</ProtectScenarios>
            </WorksheetOptions>
 
		</Worksheet>
		<Worksheet ss:Name="QEX Plus IL941 Return Info">
            <Table>
							   <Column ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="72.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="60.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="74.25"/>
   <Column ss:StyleID="s76" ss:AutoFitWidth="0" ss:Width="124.5"/>
   <Column ss:StyleID="s76" ss:AutoFitWidth="0" ss:Width="104.25"/>
   <Column ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="172.5"/>
   <Column ss:StyleID="s76" ss:AutoFitWidth="0" ss:Width="84.75"/>
   <Column ss:StyleID="s76" ss:AutoFitWidth="0" ss:Width="82.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="105.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="90"/>
   <Column ss:AutoFitWidth="0" ss:Width="96.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="81"/>
   <Column ss:AutoFitWidth="0" ss:Width="99.75"/>
   <Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="78.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="81"/>
   <Column ss:AutoFitWidth="0" ss:Width="69.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="73.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="63"/>
   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="70.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="66"/>
   <Column ss:AutoFitWidth="0" ss:Width="60.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="72"/>
   <Column ss:AutoFitWidth="0" ss:Width="66.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="65.25" ss:Span="2"/>
   <Column ss:Index="29" ss:AutoFitWidth="0" ss:Width="61.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="71.25"/>
   <Column ss:Width="57"/>
   <Column ss:AutoFitWidth="0" ss:Width="60.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="59.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="61.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="59.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="72"/>
   <Column ss:AutoFitWidth="0" ss:Width="71.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="69" ss:Span="1"/>
   <Column ss:Index="46" ss:AutoFitWidth="0" ss:Width="68.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="83.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="72.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="69"/>
   <Column ss:AutoFitWidth="0" ss:Width="65.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="74.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="68.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="92.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="74.25" ss:Span="1"/>
   <Column ss:Index="57" ss:AutoFitWidth="0" ss:Width="77.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="66.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="75"/>
   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="81"/>
   <Column ss:AutoFitWidth="0" ss:Width="66.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="57.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="61.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="69.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="66.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="65.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="58.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25" ss:Span="1"/>
   <Column ss:Index="76" ss:AutoFitWidth="0" ss:Width="58.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="60"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="60"/>
   <Column ss:AutoFitWidth="0" ss:Width="66.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="61.5" ss:Span="1"/>
   <Column ss:Index="85" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:AutoFitWidth="0" ss:Width="64.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="60"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="64.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="60.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="60.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="60"/>
   <Column ss:AutoFitWidth="0" ss:Width="60.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="72"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="65.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="69.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="69"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>
   <Column ss:Width="63"/>
   <Column ss:AutoFitWidth="0" ss:Width="76.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="73.5"/>
   <Column ss:Index="110" ss:Width="51"/>
   <Column ss:Index="112" ss:AutoFitWidth="0" ss:Width="85.5"/>
   <Column ss:Index="115" ss:Width="51"/>
   <Column ss:Index="117" ss:AutoFitWidth="0" ss:Width="72"/>
   <Column ss:Index="120" ss:AutoFitWidth="0" ss:Width="51"/>
   <Row ss:Height="74.25">
    <Cell ss:StyleID="s85"><Data ss:Type="String">EIN (EIN Number without dash)</Data></Cell>
    <Cell ss:StyleID="s86"><Data ss:Type="String">End of Period (MM/DD/YYYY)</Data></Cell>
    <Cell ss:StyleID="s87"><Data ss:Type="String">W2's Issued</Data></Cell>
    <Cell ss:StyleID="s88"><Data ss:Type="String"> Total Taxable Wages (Currency)</Data></Cell>
    <Cell ss:StyleID="s89"><Data ss:Type="String">Schedule WC Credits</Data></Cell>
    <Cell ss:StyleID="s90"><Data ss:Type="String">State Retirement Plan (1 for Yes, 0 for No)</Data></Cell>
    <Cell ss:StyleID="s88"><Data ss:Type="String">IL-501 Total Payments</Data></Cell>
    <Cell ss:StyleID="s89"><Data ss:Type="String">ILDOR Approved Credit from Previous Quarter (Amended Return)</Data></Cell>
    <Cell ss:StyleID="s78"><Data ss:Type="String">1099's Issued</Data></Cell>
    <Cell ss:StyleID="s91"><Data ss:Type="String">Not Used</Data></Cell>
    <Cell ss:StyleID="s92"><Data ss:Type="String">Return Type (IL941 or IL941X)</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Date of Final Return (MM/DD/YYYY)</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 1 (Currency)</Data></Cell>
    <Cell ss:StyleID="s94"><Data ss:Type="String">Month 1 Day 2</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 3</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 4</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 5</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 6 </Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 7</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 8</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 9</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 10</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 11</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 12</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 13</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 14</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 15</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 16</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 17</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 18</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 19</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 20</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 21</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 22</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 23</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 24</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 25</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 26</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 27</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 28</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 29</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 30</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 1 Day 31</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 1</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 2</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 3</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 4</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 5</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 6 </Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 7</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 8</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 9</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 10</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 11</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 12</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 13</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 14</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 15</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 16</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 17</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 18</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 19</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 20</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 21</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 22</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 23</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 24</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 25</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 26</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 27</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 28</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 29</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 30</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 2 Day 31</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 1</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 2</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 3</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 4</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 5</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 6 </Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 7</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 8</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 9</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 10</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 11</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 12</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 13</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 14</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 15</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 16</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 17</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 18</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 19</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 20</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 21</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 22</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 23</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 24</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 25</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 26</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 27</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 28</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 29</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 30</Data></Cell>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Month 3 Day 31</Data></Cell>
    <Cell ss:StyleID="s95"><Data ss:Type="String">Total Payroll Count (number of repeatable groups)</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">SSN 1 (repeatable group)</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">First Name 1</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">Last Name !</Data></Cell>
    <Cell ss:StyleID="s97"><Data ss:Type="String">Taxable Wages 1</Data></Cell>
    <Cell ss:StyleID="s97"><Data ss:Type="String">Tax Withheld 1</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">SSN 2 (repeatable group)</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">First Name 2</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">Last Name 2</Data></Cell>
    <Cell ss:StyleID="s97"><Data ss:Type="String">Taxable Wages 2</Data></Cell>
    <Cell ss:StyleID="s97"><Data ss:Type="String">Tax Withheld 2</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">SSN 3 (repeatable group)</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">First Name 3</Data></Cell>
    <Cell ss:StyleID="s96"><Data ss:Type="String">Last Name 3</Data></Cell>
    <Cell ss:StyleID="s97"><Data ss:Type="String">Taxable Wages 3</Data></Cell>
    <Cell ss:StyleID="s97"><Data ss:Type="String">Tax Withheld 3</Data></Cell>
   </Row>
   <Row>
    <Cell ss:StyleID="s98"/>
    <Cell ss:StyleID="s98"/>
    <Cell ss:StyleID="s98"><Data ss:Type="String">.A</Data></Cell>
    <Cell ss:StyleID="s98"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s98"><Data ss:Type="Number">3</Data></Cell>
    <Cell ss:StyleID="s71"><Data ss:Type="Number">4</Data></Cell>
    <Cell ss:StyleID="s98"><Data ss:Type="String">5a</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">5b</Data></Cell>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"><Data ss:Type="Number">18</Data></Cell>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:Index="109" ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
    <Cell ss:StyleID="s99"/>
   </Row>
   <Row></Row>
							<xsl:apply-templates select="Hosts/ExtractHost" mode="i941">
								<xsl:sort select="HostCompany/TaxFilingName"/>
							</xsl:apply-templates>
		 
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
                <PageSetup>
                    <Header x:Margin="0.3" />
                    <Footer x:Margin="0.3" />
                    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75" />
                </PageSetup>
                <Print>
                    <ValidPrinterInfo/>
                    <HorizontalResolution>600</HorizontalResolution>
                    <VerticalResolution>600</VerticalResolution>
                </Print>
                <ProtectObjects>False</ProtectObjects>
                <ProtectScenarios>False</ProtectScenarios>
            </WorksheetOptions>
 </Worksheet>
 

	</xsl:template>


	<xsl:template match="ExtractHost" mode="CompanyInfo">
		
			<Row>
				<Cell><Data ss:Type="String"><xsl:value-of select="concat(substring(HostCompany/FederalEIN,1,2),'-',substring(HostCompany/FederalEIN,3,7))"/></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="substring(translate(HostCompany/TaxFilingName,1,4), $smallcase, $uppercase)"/></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="translate(HostCompany/TaxFilingName,$smallcase,$uppercase)"/></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="translate(HostCompany/BusinessAddress/AddressLine1,$smallcase,$uppercase)"/></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="translate(HostCompany/BusinessAddress/City,$smallcase,$uppercase)"/></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="translate(States/CompanyTaxState[position()=1]/State/Abbreviation,$smallcase,$uppercase)"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="HostCompany/BusinessAddress/Zip"/></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="translate(Host/FirmName,$smallcase,$uppercase)"/></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String">
					<xsl:value-of select="translate(concat(Contact/FirstName, ' ', Contact/LastName), $smallcase, $uppercase)"/>
				</Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="Contact/Phone"/></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="$todaydate"/></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="translate(Host/PTIN,$smallcase,$uppercase)"/></Data></Cell>
			</Row>
		
	</xsl:template>
	<xsl:template match="ExtractHost" mode="i941">
		<xsl:variable name="ssConst" select="(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employee']/Tax/Rate + PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employer']/Tax/Rate) div 100"/>
		<xsl:variable name="mdConst" select="(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee']/Tax/Rate + PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employer']/Tax/Rate) div 100"/>
		<xsl:variable name="totalTips" select="sum(PayCheckAccumulation/Compensations/PayCheckCompensation[PayTypeId=3]/YTD)"/>
		<xsl:variable name="totalFITWages" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage"/>
		<xsl:variable name="totalSSWages" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage - $totalTips"/>

		<xsl:variable name="totalMDWages" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage"/>
		<xsl:variable name="totalFITTax" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT']/YTD"/>
		<xsl:variable name="totalSSTax" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employee' or Tax/Code='SS_Employer']/YTD)"/>
		<xsl:variable name="totalMDTax" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee' or Tax/Code='MD_Employer']/YTD)"/>


			<xsl:variable name="line5d" select="format-number($totalSSWages*$ssConst,'######0.00') + format-number($totalTips*$ssConst,'######0.00') + format-number($totalMDWages*$mdConst,'######0.00')"/>	
			<xsl:variable name="line6" select="$totalFITTax + $line5d"/>	
			<xsl:variable name="line7" select="$totalSSTax + $totalMDTax - $line5d"/>	
			<xsl:variable name="line8" select="($line6 + $line7)"/>
			<xsl:variable name="line11" select="($totalFITTax + $totalSSTax + $totalMDTax)"/>
		<xsl:variable name="deposit" select="PayCheckAccumulation/PayCheckWages/DepositAmount"/>
		
		
			<Row>
				<Cell><Data ss:Type="String"><xsl:value-of select="translate(HostCompany/FederalEIN,'-','')"/></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="$enddate"/></Data></Cell>
				<Cell><Data ss:Type="String">
				<xsl:choose>
					<xsl:when test="PayCheckAccumulation/PayCheckWages/Twelve3"><xsl:value-of select="PayCheckAccumulation/PayCheckWages/Twelve3"/></xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
				</Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalFITWages,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalFITTax,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number">0</Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalSSWages,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalTips,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalMDWages,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number">0</Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($line7,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number"></Data></Cell>
				<Cell><Data ss:Type="Number"></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($deposit,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="Number">0</Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				
				<xsl:choose>
					<xsl:when test="HostCompany/DepositSchedule='Monthly'">
							<Cell><Data ss:Type="String">M</Data></Cell>
							<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/MonthlyAccumulations/MonthlyAccumulation[Month=($quarter - 1)*3+1]"><xsl:value-of select="format-number(sum(PayCheckAccumulation/MonthlyAccumulations/MonthlyAccumulation[Month=($quarter - 1)*3+1]/IRS941),'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
						<Cell>
							<Data ss:Type="Number">
								<xsl:choose>
									<xsl:when test="PayCheckAccumulation/MonthlyAccumulations/MonthlyAccumulation[Month=($quarter - 1)*3+2]">
										<xsl:value-of select="format-number(sum(PayCheckAccumulation/MonthlyAccumulations/MonthlyAccumulation[Month=($quarter - 1)*3+2]/IRS941),'#,###,##0.00')"/>
									</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</Data>
						</Cell>
						<Cell>
							<Data ss:Type="Number">
								<xsl:choose>
									<xsl:when test="PayCheckAccumulation/MonthlyAccumulations/MonthlyAccumulation[Month=($quarter - 1)*3+3]">
										<xsl:value-of select="format-number(sum(PayCheckAccumulation/MonthlyAccumulations/MonthlyAccumulation[Month=($quarter - 1)*3+3]/IRS941),'#,###,##0.00')"/>
									</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</Data>
						</Cell>
							<Cell><Data ss:Type="String"><xsl:choose>
							<xsl:when test="format-number($line11,'#.00')>format-number($line8,'#.00')">R</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose></Data></Cell>
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="HostCompany/DepositSchedule='SemiWeekly'">
							<Cell><Data ss:Type="String">S</Data></Cell>
							<Cell><Data ss:Type="Number">0</Data></Cell>
							<Cell><Data ss:Type="Number">0</Data></Cell>
							<Cell><Data ss:Type="Number">0</Data></Cell>
							<Cell><Data ss:Type="String"><xsl:choose>
									<xsl:when test="format-number($line11,'#.00')>format-number($line8,'#.00')">R</xsl:when>
									<xsl:otherwise></xsl:otherwise>
									</xsl:choose></Data></Cell>
							<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=1]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=1]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
							<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=2]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=2]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=3]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=3]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=4]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=4]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=5]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=5]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=6]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=6]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=7]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=7]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=8]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=8]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=9]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=9]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=10]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=10]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=11]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=11]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=12]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=12]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=13]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=13]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=14]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=14]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=15]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=15]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=16]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=16]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=17]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=17]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=18]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=18]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=19]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=19]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=20]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=20]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=21]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=21]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=22]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=22]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=23]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=23]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=24]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=24]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=25]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=25]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=26]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=26]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=27]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=27]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=28]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=28]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=29]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=29]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=30]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=30]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=31]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+1 and Day=31]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=1]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=1]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=2]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=2]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=3]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=3]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=4]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=4]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=5]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=5]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=6]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=6]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=7]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=7]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=8]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=8]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=9]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=9]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=10]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=10]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=11]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=11]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=12]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=12]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=13]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=13]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=14]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=14]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=15]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=15]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=16]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=16]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=17]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=17]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=18]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=18]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=19]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=19]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=20]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=20]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=21]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=21]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=22]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=22]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=23]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=23]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=24]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=24]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=25]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=25]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=26]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=26]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=27]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=27]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=28]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=28]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=29]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=29]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=30]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=30]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=31]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+2 and Day=31]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=1]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=1]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=2]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=2]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=3]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=3]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=4]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=4]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=5]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=5]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=6]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=6]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=7]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=7]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=8]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=8]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=9]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=9]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=10]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=10]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=11]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=11]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=12]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=12]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=13]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=13]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=14]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=14]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=15]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=15]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=16]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=16]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=17]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=17]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=18]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=18]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=19]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=19]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=20]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=20]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=21]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=21]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=22]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=22]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=23]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=23]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=24]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=24]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=25]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=25]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=26]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=26]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=27]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=27]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=28]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=28]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=29]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=29]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=30]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=30]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=31]"><xsl:value-of select="format-number(PayCheckAccumulation/DailyAccumulations/DailyAccumulation[Month=($quarter - 1)*3+3 and Day=31]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>

							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				
				
				<Cell><Data ss:Type="String"><xsl:choose>
							<xsl:when test="format-number($line11,'#.00')>format-number($line8,'#.00')">R</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose></Data></Cell>
			</Row>
		
	</xsl:template>
	




</xsl:stylesheet>