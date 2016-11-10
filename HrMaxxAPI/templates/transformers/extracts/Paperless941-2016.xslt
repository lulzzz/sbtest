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
            <Alignment ss:Vertical="Bottom"/> <Borders/> <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/> <Interior/> <NumberFormat/> <Protection/>
            </Style>
            <Style ss:ID="s19">
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
  <Style ss:ID="s20">
   <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
   <NumberFormat ss:Format="00000"/>
  </Style>
  <Style ss:ID="s21">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
  </Style>
  <Style ss:ID="s22">
   <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
   <NumberFormat ss:Format="00000"/>
  </Style>
  <Style ss:ID="s23">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
   <NumberFormat ss:Format="00000"/>
  </Style>
            <Style ss:ID="s63">
            <NumberFormat ss:Format="@"/>
            </Style>
            <Style ss:ID="s64">
            <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="00000"/>
            </Style>
            <Style ss:ID="s65">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="00000"/>
            </Style>
            <Style ss:ID="s66">
            <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="00000"/>
            </Style>
            <Style ss:ID="s67">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="00000"/>
            </Style>
            <Style ss:ID="s68">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
            </Style>
            <Style ss:ID="s69">
            <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="00000"/>
            </Style>
            <Style ss:ID="s70">
            <Alignment ss:Vertical="Bottom" ss:Rotate="45"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
            </Style>
            <Style ss:ID="s71">
            <Alignment ss:Vertical="Bottom" ss:Rotate="45"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="@"/>
            </Style>
            <Style ss:ID="s72">
            <Alignment ss:Vertical="Bottom" ss:Rotate="45"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="Fixed"/>
            </Style>
            <Style ss:ID="s73">
            <Alignment ss:Vertical="Bottom" ss:Rotate="45"/> <Borders> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="Fixed"/>
            </Style>
            <Style ss:ID="s74">
            <Alignment ss:Vertical="Bottom" ss:Rotate="45"/> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
            </Style>
            <Style ss:ID="s75">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="@"/>
            </Style>
            <Style ss:ID="s76">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <NumberFormat ss:Format="Fixed"/>
            </Style>
            <Style ss:ID="s77">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders>
            </Style>
            <Style ss:ID="s78">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="@"/>
            </Style>
            <Style ss:ID="s79">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="#,##0.00;\-#,##0.00"/>
            </Style>
            <Style ss:ID="s80">
            <NumberFormat ss:Format="#,##0.00;\-#,##0.00"/>
            </Style>
            <Style ss:ID="s81">
            <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="@"/>
            </Style>
            <Style ss:ID="s82">
            <NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
            </Style>
            <Style ss:ID="s83">
            <NumberFormat ss:Format="&quot;$&quot;#,##0.00"/>
            </Style>
            <Style ss:ID="s84">
            <Alignment ss:Vertical="Bottom" ss:Rotate="45"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior ss:Color="#000000" ss:Pattern="Solid"/>
            </Style>
            <Style ss:ID="s85">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior ss:Color="#000000" ss:Pattern="Solid"/>
            </Style>
            <Style ss:ID="s86">
            <Interior ss:Color="#000000" ss:Pattern="Solid"/>
            </Style>
            <Style ss:ID="s87">
            <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
            </Style>
            <Style ss:ID="s88">
            <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
            </Style>
            <Style ss:ID="s89">
            <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="&quot;$&quot;#,##0.00"/>
            </Style>
            <Style ss:ID="s90">
            <Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat/>
            </Style>
            <Style ss:ID="s91">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat/>
            </Style>
            <Style ss:ID="s92">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat/>
            </Style>
            <Style ss:ID="s93">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat/>
            </Style>
            <Style ss:ID="s94">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat/>
            </Style>
            <Style ss:ID="s95">
            <NumberFormat/>
            </Style>
            <Style ss:ID="s96">
            <Alignment ss:Vertical="Bottom" ss:Rotate="45"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>
            </Style>
            <Style ss:ID="s97">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>
            </Style>
            <Style ss:ID="s98">
            <Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>
            </Style>
            <Style ss:ID="s99">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/> <NumberFormat ss:Format="00000"/>
            </Style>
            <Style ss:ID="s100">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/> <NumberFormat ss:Format="0"/>
            </Style>
            <Style ss:ID="s101">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="0"/>
            </Style>
            <Style ss:ID="s102">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="00000"/>
            </Style>
            <Style ss:ID="s103">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <NumberFormat ss:Format="@"/>
            </Style>
            <Style ss:ID="s104">
            <Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/> <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <NumberFormat ss:Format="@"/>
            </Style>
            <Style ss:ID="s105">
            <Borders> <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/> <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/> </Borders> <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/> <Interior/> <NumberFormat ss:Format="@"/>
            </Style>
        </Styles>
  			<xsl:apply-templates/>
		</Workbook>
	</xsl:template>


	<xsl:template match="ExtractResponse">
	
		<Worksheet ss:Name="QEX 2016 Company Information">
            <Table >
                <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="58.5" />
                <Column ss:AutoFitWidth="0" ss:Width="61.5" />
                <Column ss:AutoFitWidth="0" ss:Width="113.25" />
                <Column ss:AutoFitWidth="0" ss:Width="112.5" />
                <Column ss:AutoFitWidth="0" ss:Width="124.5" />
                <Column ss:StyleID="s86" ss:AutoFitWidth="0" ss:Width="114" />
                <Column ss:AutoFitWidth="0" ss:Width="99.75" />
                <Column ss:AutoFitWidth="0" ss:Width="75" />
                <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="68.25" />
                <Column ss:AutoFitWidth="0" ss:Width="104.25" />
                <Column ss:AutoFitWidth="0" ss:Width="77.25" />
                <Column ss:Index="14" ss:AutoFitWidth="0" ss:Width="61.5" />
                <Column ss:Index="17" ss:AutoFitWidth="0" ss:Width="72" />
                <Column ss:Index="19" ss:StyleID="s63" ss:Width="52.5" />
                <Column ss:Index="22" ss:StyleID="s98" ss:AutoFitWidth="0" ss:Width="46.5" />
    <Column ss:AutoFitWidth="0" ss:Width="57.75" />
                <Row ss:AutoFitHeight="0" ss:Height="66">
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">EIN </Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Name Control</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Business Name 1</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Business Name 2</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Address 1</Data>
                    </Cell>
                    <Cell ss:StyleID="s84">
                        <Data ss:Type="String">Address 2 - The IRS cannot support use of this field.</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">City</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">State</Data>
                    </Cell>
                    <Cell ss:StyleID="s71">
                        <Data ss:Type="String">Zip Code</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Preparer / Agent Name</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Preparer / Agent Title</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Company Contact Name</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Company Contact Title</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Phone Number</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">e-Mail Address</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Signature Name</Data>
                    </Cell>
                    <Cell ss:StyleID="s70">
                        <Data ss:Type="String">Signature Date</Data>
                    </Cell>
                    <Cell ss:StyleID="s72">
                        <Data ss:Type="String">Account Type</Data>
                    </Cell>
                    <Cell ss:StyleID="s71">
                        <Data ss:Type="String">Routing Number</Data>
                    </Cell>
                    <Cell ss:StyleID="s73">
                        <Data ss:Type="String">Account Number</Data>
                    </Cell>
                    <Cell ss:StyleID="s73">
                        <Data ss:Type="String">Online PIN ( For Indirect Filers Only)</Data>
                    </Cell>
                    <Cell ss:StyleID="s96">
                        <Data ss:Type="String">Address Change - Capital &quot;U&quot; if Address has changed</Data>
                    </Cell>
                    <Cell ss:StyleID="s74" />
                </Row>
                <Row>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String"> </Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String"> </Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s85">
                        <Data ss:Type="String">Do Not Use</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s75">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s68">
                        <Data ss:Type="String">R</Data>
                    </Cell>
                    <Cell ss:StyleID="s76">
                        <Data ss:Type="String"> </Data>
                    </Cell>
                    <Cell ss:StyleID="s103" />
                    <Cell ss:StyleID="s76" />
                    <Cell ss:StyleID="s77" />
                    <Cell ss:StyleID="s97" />
                </Row>
            
   <Row></Row>
   <xsl:apply-templates select="Hosts/ExtractHost[count(Accumulation/PayChecks/PayCheck)>0]" mode="CompanyInfo"/>
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
		<Worksheet ss:Name="QEX 941 2016 Return Information">
            <Table>
                <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="72" />
                <Column ss:AutoFitWidth="0" ss:Width="60.75" />
                <Column ss:AutoFitWidth="0" ss:Width="75" />
                <Column ss:StyleID="s82" ss:AutoFitWidth="0" ss:Width="124.5" />
                <Column ss:StyleID="s82" ss:AutoFitWidth="0" ss:Width="104.25" />
                <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="171.75" />
                <Column ss:StyleID="s82" ss:AutoFitWidth="0" ss:Width="85.5" />
                <Column ss:StyleID="s82" ss:AutoFitWidth="0" ss:Width="82.5" ss:Span="1" />
                <Column ss:Index="10" ss:StyleID="s83" ss:AutoFitWidth="0" ss:Width="80.25" />
                <Column ss:StyleID="s83" ss:AutoFitWidth="0" ss:Width="81.75" />
                <Column ss:AutoFitWidth="0" ss:Width="56.25" />
                <Column ss:AutoFitWidth="0" ss:Width="82.5" />
                <Column ss:AutoFitWidth="0" ss:Width="74.25" />
                <Column ss:AutoFitWidth="0" ss:Width="115.5" />
                <Column ss:AutoFitWidth="0" ss:Width="116.25" />
                <Column ss:AutoFitWidth="0" ss:Width="144" />
                <Column ss:AutoFitWidth="0" ss:Width="106.5" />
                <Column ss:AutoFitWidth="0" ss:Width="90" />
                <Column ss:AutoFitWidth="0" ss:Width="96" />
                <Column ss:AutoFitWidth="0" ss:Width="80.25" />
                <Column ss:AutoFitWidth="0" ss:Width="133.5" />
                <Column ss:AutoFitWidth="0" ss:Width="96.75" />
                <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="72.75" />
                <Column ss:AutoFitWidth="0" ss:Width="81" />
                <Column ss:AutoFitWidth="0" ss:Width="90" />
                <Column ss:AutoFitWidth="0" ss:Width="84.75" />
                <Column ss:AutoFitWidth="0" ss:Width="87.75" />
                <Column ss:AutoFitWidth="0" ss:Width="120.75" />
                <Column ss:AutoFitWidth="0" ss:Width="107.25" />
                <Column ss:AutoFitWidth="0" ss:Width="99.75" />
                <Column ss:StyleID="s80" ss:AutoFitWidth="0" ss:Width="78.75" />
                <Column ss:AutoFitWidth="0" ss:Width="81" />
                <Column ss:AutoFitWidth="0" ss:Width="69.75" />
                <Column ss:AutoFitWidth="0" ss:Width="73.5" />
                <Column ss:AutoFitWidth="0" ss:Width="63" />
                <Column ss:AutoFitWidth="0" ss:Width="67.5" />
                <Column ss:AutoFitWidth="0" ss:Width="70.5" />
                <Column ss:AutoFitWidth="0" ss:Width="66" />
                <Column ss:AutoFitWidth="0" ss:Width="60.75" />
                <Column ss:AutoFitWidth="0" ss:Width="63.75" />
                <Column ss:AutoFitWidth="0" ss:Width="72" />
                <Column ss:AutoFitWidth="0" ss:Width="66.75" />
                <Column ss:AutoFitWidth="0" ss:Width="65.25" ss:Span="2" />
                <Column ss:Index="47" ss:AutoFitWidth="0" ss:Width="61.5" />
                <Column ss:AutoFitWidth="0" ss:Width="62.25" />
                <Column ss:AutoFitWidth="0" ss:Width="71.25" />
                <Column ss:Width="57" />
                <Column ss:AutoFitWidth="0" ss:Width="60.75" />
                <Column ss:AutoFitWidth="0" ss:Width="63.75" />
                <Column ss:AutoFitWidth="0" ss:Width="59.25" />
                <Column ss:AutoFitWidth="0" ss:Width="61.5" />
                <Column ss:AutoFitWidth="0" ss:Width="62.25" />
                <Column ss:AutoFitWidth="0" ss:Width="63.75" />
                <Column ss:AutoFitWidth="0" ss:Width="62.25" />
                <Column ss:AutoFitWidth="0" ss:Width="59.25" />
                <Column ss:AutoFitWidth="0" ss:Width="62.25" />
                <Column ss:AutoFitWidth="0" ss:Width="72" />
                <Column ss:AutoFitWidth="0" ss:Width="71.25" />
                <Column ss:AutoFitWidth="0" ss:Width="69" />
                <Column ss:AutoFitWidth="0" ss:Width="69.75" />
                <Column ss:AutoFitWidth="0" ss:Width="68.25" />
                <Column ss:AutoFitWidth="0" ss:Width="83.25" />
                <Column ss:AutoFitWidth="0" ss:Width="72.75" />
                <Column ss:AutoFitWidth="0" ss:Width="69" />
                <Column ss:AutoFitWidth="0" ss:Width="65.25" />
                <Column ss:AutoFitWidth="0" ss:Width="75" />
                <Column ss:AutoFitWidth="0" ss:Width="68.25" />
                <Column ss:AutoFitWidth="0" ss:Width="62.25" />
                <Column ss:AutoFitWidth="0" ss:Width="92.25" />
                <Column ss:AutoFitWidth="0" ss:Width="74.25" />
                <Column ss:AutoFitWidth="0" ss:Width="75" />
                <Column ss:AutoFitWidth="0" ss:Width="77.25" />
                <Column ss:AutoFitWidth="0" ss:Width="66.75" />
                <Column ss:AutoFitWidth="0" ss:Width="75" />
                <Column ss:AutoFitWidth="0" ss:Width="67.5" />
                <Column ss:AutoFitWidth="0" ss:Width="81" />
                <Column ss:AutoFitWidth="0" ss:Width="66.75" />
                <Column ss:AutoFitWidth="0" ss:Width="57.75" />
                <Column ss:AutoFitWidth="0" ss:Width="67.5" />
                <Column ss:AutoFitWidth="0" ss:Width="61.5" />
                <Column ss:AutoFitWidth="0" ss:Width="56.25" />
                <Column ss:AutoFitWidth="0" ss:Width="64.5" />
                <Column ss:AutoFitWidth="0" ss:Width="69.75" />
                <Column ss:AutoFitWidth="0" ss:Width="66.75" />
                <Column ss:AutoFitWidth="0" ss:Width="65.25" />
                <Column ss:AutoFitWidth="0" ss:Width="66.75" />
                <Column ss:AutoFitWidth="0" ss:Width="63.75" />
                <Column ss:AutoFitWidth="0" ss:Width="58.5" />
                <Column ss:AutoFitWidth="0" ss:Width="62.25" ss:Span="1" />
                <Column ss:Index="94" ss:AutoFitWidth="0" ss:Width="59.25" />
                <Column ss:AutoFitWidth="0" ss:Width="60" />
                <Column ss:AutoFitWidth="0" ss:Width="62.25" />
                <Column ss:AutoFitWidth="0" ss:Width="60" />
                <Column ss:AutoFitWidth="0" ss:Width="66.75" />
                <Column ss:AutoFitWidth="0" ss:Width="67.5" />
                <Column ss:AutoFitWidth="0" ss:Width="64.5" />
                <Column ss:AutoFitWidth="0" ss:Width="61.5" ss:Span="1" />
                <Column ss:Index="103" ss:AutoFitWidth="0" ss:Width="56.25" />
                <Column ss:AutoFitWidth="0" ss:Width="64.5" />
                <Column ss:AutoFitWidth="0" ss:Width="60" />
                <Column ss:AutoFitWidth="0" ss:Width="63.75" />
                <Column ss:AutoFitWidth="0" ss:Width="64.5" />
                <Column ss:AutoFitWidth="0" ss:Width="60.75" />
                <Column ss:AutoFitWidth="0" ss:Width="63.75" />
                <Column ss:AutoFitWidth="0" ss:Width="60.75" />
                <Column ss:AutoFitWidth="0" ss:Width="60" />
                <Column ss:AutoFitWidth="0" ss:Width="60.75" />
                <Column ss:AutoFitWidth="0" ss:Width="63.75" />
                <Column ss:AutoFitWidth="0" ss:Width="72" />
                <Column ss:AutoFitWidth="0" ss:Width="63.75" />
                <Column ss:AutoFitWidth="0" ss:Width="66.75" />
                <Column ss:AutoFitWidth="0" ss:Width="64.5" />
                <Column ss:AutoFitWidth="0" ss:Width="65.25" />
                <Column ss:AutoFitWidth="0" ss:Width="69.75" />
                <Column ss:AutoFitWidth="0" ss:Width="69" />
                <Column ss:AutoFitWidth="0" ss:Width="64.5" />
                <Column ss:AutoFitWidth="0" ss:Width="62.25" />
                <Column ss:Width="63" />
                <Row ss:Height="67.5">
                    <Cell ss:StyleID="s81">
                        <Data ss:Type="String">EIN (EIN Number without dash)</Data>
                    </Cell>
                    <Cell ss:StyleID="s64">
                        <Data ss:Type="String">End of Period (MM/DD/YYYY)</Data>
                    </Cell>
                    <Cell ss:StyleID="s64">
                        <Data ss:Type="String">Employees (Positive Integer)</Data>
                    </Cell>
                    <Cell ss:StyleID="s87">
                        <Data ss:Type="String"> Total Wages (Currency) (Ignored for Return Types PR and SS)</Data>
                    </Cell>
                    <Cell ss:StyleID="s87">
                        <Data ss:Type="String">Total Tax Withheld (Currency) (Ignored for Return Types PR and SS)</Data>
                    </Cell>
                    <Cell ss:StyleID="s104">
                        <Data ss:Type="String">Wages not Subject to SS/Medicare (Valid Values 1 for Yes, 0 for No) If 1 or Yes, 5a through 5d will be ignored.</Data>
                    </Cell>
                    <Cell ss:StyleID="s87">
                        <Data ss:Type="String">Taxable SS Wages (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s87">
                        <Data ss:Type="String">Taxable SS Tips (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s88">
                        <Data ss:Type="String">Taxable Medicare Wages (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s89">
                        <Data ss:Type="String">Additional Taxable Medicare wages and tips (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s89">
                        <Data ss:Type="String">Taxable Unreported Tips 3121q (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s69">
                        <Data ss:Type="String">Not Used</Data>
                    </Cell>
                    <Cell ss:StyleID="s69">
                        <Data ss:Type="String">Not Used</Data>
                    </Cell>
                    <Cell ss:StyleID="s66">
                        <Data ss:Type="String">Current Quarter's Fractions of Cents (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s64">
                        <Data ss:Type="String">Current Quarter's Sick Pay (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Current Quarter's Adjustment for tips and Group-Term Life Insurance (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s99">
                        <Data ss:Type="String">Not Used</Data>
                    </Cell>
                    <Cell ss:StyleID="s100">
                        <Data ss:Type="String">Not Used</Data>
                    </Cell>
                    <Cell ss:StyleID="s101">
                        <Data ss:Type="String">Not Used</Data>
                    </Cell>
                    <Cell ss:StyleID="s102">
                        <Data ss:Type="String">Not Used</Data>
                    </Cell>
                    <Cell ss:StyleID="s102">
                        <Data ss:Type="String">Not Used</Data>
                    </Cell>
                    <Cell ss:StyleID="s67">
                        <Data ss:Type="String">Total Deposits (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s78">
                        <Data ss:Type="String">Return Type (Default is Form 941) (Values:PR,SS or Blank)</Data>
                    </Cell>
                    <Cell ss:StyleID="s104">
                        <Data ss:Type="String">Seasonal ( 1 for Yes, and 0 for No)</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Date of Final Return (MM/DD/YYYY)</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Monthly or Semi-Weekly (Valid Values are M, S or Blank)</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">First Month Liability (Only if M in Monthly or Semi-Monthly column)</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Second Month Liability (Only if M in Monthly or Semi-Monthly column)</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Third Month Liability (Only if M in Monthly or Semi-Monthly column)</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Refund or Apply to Next Return ( for Overpayment Only ) Default to R</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 1 (Currency)</Data>
                    </Cell>
                    <Cell ss:StyleID="s79">
                        <Data ss:Type="String">Schedule B Month 1 Day 2</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 3</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 4</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 5</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 6 </Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 7</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 8</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 9</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 10</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 11</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 12</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 13</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 14</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 15</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 16</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 17</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 18</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 19</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 20</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 21</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 22</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 23</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 24</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 25</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 26</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 27</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 28</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 29</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 30</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 1 Day 31</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 1</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 2</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 3</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 4</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 5</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 6 </Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 7</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 8</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 9</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 10</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 11</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 12</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 13</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 14</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 15</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 16</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 17</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 18</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 19</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 20</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 21</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 22</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 23</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 24</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 25</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 26</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 27</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 28</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 29</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 30</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 2 Day 31</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 1</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 2</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 3</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 4</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 5</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 6 </Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 7</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 8</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 9</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 10</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 11</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 12</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 13</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 14</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 15</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 16</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 17</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 18</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 19</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 20</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 21</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 22</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 23</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 24</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 25</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 26</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 27</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 28</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 29</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 30</Data>
                    </Cell>
                    <Cell ss:StyleID="s65">
                        <Data ss:Type="String">Schedule B Month 3 Day 31</Data>
                    </Cell>
                    <Cell ss:StyleID="s68" />
                </Row>
                <Row ss:StyleID="s95">
                    <Cell ss:StyleID="s90" />
                    <Cell ss:StyleID="s90" />
                    <Cell ss:StyleID="s90">
                        <Data ss:Type="Number">1</Data>
                    </Cell>
                    <Cell ss:StyleID="s90">
                        <Data ss:Type="Number">2</Data>
                    </Cell>
                    <Cell ss:StyleID="s90">
                        <Data ss:Type="Number">3</Data>
                    </Cell>
                    <Cell ss:StyleID="s75">
                        <Data ss:Type="Number">4</Data>
                    </Cell>
                    <Cell ss:StyleID="s90">
                        <Data ss:Type="String">5a</Data>
                    </Cell>
                    <Cell ss:StyleID="s91">
                        <Data ss:Type="String">5b</Data>
                    </Cell>
                    <Cell ss:StyleID="s92">
                        <Data ss:Type="String">5c</Data>
                    </Cell>
                    <Cell ss:StyleID="s93">
                        <Data ss:Type="String">5d</Data>
                    </Cell>
                    <Cell ss:StyleID="s94">
                        <Data ss:Type="String">6a</Data>
                    </Cell>
                    <Cell ss:StyleID="s93">
                        <Data ss:Type="String">6b</Data>
                    </Cell>
                    <Cell ss:StyleID="s91">
                        <Data ss:Type="String">7a</Data>
                    </Cell>
                    <Cell ss:StyleID="s91">
                        <Data ss:Type="String">7b</Data>
                    </Cell>
                    <Cell ss:StyleID="s91">
                        <Data ss:Type="String">7c</Data>
                    </Cell>
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s92" />
                    <Cell ss:StyleID="s93" />
                    <Cell ss:StyleID="s93" />
                    <Cell ss:StyleID="s93">
                        <Data ss:Type="Number">9</Data>
                    </Cell>
                    <Cell ss:StyleID="s94">
                        <Data ss:Type="Number">11</Data>
                    </Cell>
                    <Cell ss:StyleID="s93" />
                    <Cell ss:StyleID="s93">
                        <Data ss:Type="Number">18</Data>
                    </Cell>
                    <Cell ss:StyleID="s105">
                        <Data ss:Type="Number">17</Data>
                    </Cell>
                    <Cell ss:StyleID="s93" />
                    <Cell ss:StyleID="s93">
                        <Data ss:Type="Number">16</Data>
                    </Cell>
                    <Cell ss:StyleID="s93">
                        <Data ss:Type="Number">16</Data>
                    </Cell>
                    <Cell ss:StyleID="s93">
                        <Data ss:Type="Number">16</Data>
                    </Cell>
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91">
                        <Data ss:Type="String"> </Data>
                    </Cell>
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91">
                        <Data ss:Type="String"> </Data>
                    </Cell>
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                    <Cell ss:StyleID="s91" />
                </Row>
   <Row></Row>
   <xsl:apply-templates select="Hosts/ExtractHost[count(Accumulation/PayChecks/PayCheck)>0]" mode="i941"/>
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
 <Worksheet ss:Name="777777777">
  <Table x:FullColumns="1"
   x:FullRows="1" ss:DefaultRowHeight="15">
   <Column ss:Width="52.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="63"/>
   <Column ss:AutoFitWidth="0" ss:Width="92.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="93.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="97.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="110.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="106.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="76.5"/>
   <Row ss:AutoFitHeight="0" ss:Height="72.75">
    <Cell ss:StyleID="s19"><Data ss:Type="String">Client EIN</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Total Wages</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Total Tax Withheld</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Taxable SS Wages</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Taxable SS Tips</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Taxable Medicare Wages</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Advanced EIC</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Total Deposits</Data></Cell>
   </Row>
   <Row>
    <Cell ss:StyleID="s22"><Data ss:Type="String">a</Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">b</Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">c</Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">d</Data></Cell>
    <Cell ss:StyleID="s23"><Data ss:Type="String">d</Data></Cell>
    <Cell ss:StyleID="s23"><Data ss:Type="String">d</Data></Cell>
    <Cell ss:StyleID="s23"><Data ss:Type="String">f</Data></Cell>
    <Cell ss:StyleID="s23"><Data ss:Type="String">g</Data></Cell>
   </Row>
   <Row></Row>
   <xsl:apply-templates select="Hosts/ExtractHost[count(Accumulation/PayChecks/PayCheck)>0]" mode="i777"/>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Selected/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>4</ActiveRow>
    </Pane>
   </Panes>
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
		<xsl:variable name="ssConst" select="(Accumulation/Taxes/PayrollTax[Tax/Id=4]/Tax/Rate + Accumulation/Taxes/PayrollTax[Tax/Id=5]/Tax/Rate) div 100"/>
		<xsl:variable name="mdConst" select="(Accumulation/Taxes/PayrollTax[Tax/Id=2]/Tax/Rate + Accumulation/Taxes/PayrollTax[Tax/Id=3]/Tax/Rate) div 100"/>
		<xsl:variable name="totalTips" select="sum(Accumulation/Compensations[PayType/Id=3]/Amount)"/>
		<xsl:variable name="totalFITWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=1]/TaxableWage"/>
		<xsl:variable name="totalSSWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=4]/TaxableWage"/>

		<xsl:variable name="totalMDWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=2]/TaxableWage"/>
		<xsl:variable name="totalFITTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=1]/Amount"/>
		<xsl:variable name="totalSSTax" select="(Accumulation/Taxes/PayrollTax[Tax/Id=4]/Amount + Accumulation/Taxes/PayrollTax[Tax/Id=5]/Amount)"/>
		<xsl:variable name="totalMDTax" select="(Accumulation/Taxes/PayrollTax[Tax/Id=2]/Amount + Accumulation/Taxes/PayrollTax[Tax/Id=3]/Amount)"/>


			<xsl:variable name="line5d" select="format-number($totalSSWages*$ssConst,'######0.00') + format-number($totalTips*$ssConst,'######0.00') + format-number($totalMDWages*$mdConst,'######0.00')"/>	
			<xsl:variable name="line6" select="$totalFITTax + $line5d"/>	
			<xsl:variable name="line7" select="$totalSSTax + $totalMDTax - $line5d"/>	
			<xsl:variable name="line8" select="($line6 + $line7)"/>
			<xsl:variable name="line11" select="($totalFITTax + $totalSSTax + $totalMDTax)"/>
		
		
			<Row>
				<Cell><Data ss:Type="Number"><xsl:value-of select="translate(HostCompany/FederalEIN,'-','')"/></Data></Cell>
				<Cell><Data ss:Type="String"><xsl:value-of select="$enddate"/></Data></Cell>
				<Cell><Data ss:Type="Number">
				<xsl:choose>
					<xsl:when test="Accumulation/Count3"><xsl:value-of select="Accumulation/Count3"/></xsl:when>
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
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($line11,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="Number">0</Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				
				<xsl:choose>
					<xsl:when test="HostCompany//DepositSchedule='Monthly'">
							<Cell><Data ss:Type="String">M</Data></Cell>
							<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1]"><xsl:value-of select="format-number(sum(Accumulation/DailyAccumulations/DailyAccumulation[Month=1]/Value),'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
						<Cell>
							<Data ss:Type="Number">
								<xsl:choose>
									<xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2]">
										<xsl:value-of select="format-number(sum(Accumulation/DailyAccumulations/DailyAccumulation[Month=2]/Value),'#,###,##0.00')"/>
									</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</Data>
						</Cell>
						<Cell>
							<Data ss:Type="Number">
								<xsl:choose>
									<xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3]">
										<xsl:value-of select="format-number(sum(Accumulation/DailyAccumulations/DailyAccumulation[Month=3]/Value),'#,###,##0.00')"/>
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
							<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=1]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=1]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
							<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=2]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=2]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=3]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=3]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=4]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=4]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=5]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=5]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=6]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=6]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=7]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=7]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=8]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=8]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=9]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=9]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=10]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=10]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=11]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=11]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=12]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=12]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=13]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=13]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=14]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=14]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=15]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=15]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=16]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=16]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=17]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=17]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=18]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=18]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=19]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=19]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=20]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=20]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=21]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=21]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=22]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=22]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=23]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=23]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=24]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=24]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=25]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=25]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=26]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=26]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=27]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=27]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=28]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=28]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=29]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=29]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=30]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=30]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=31]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=1 and Day=31]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=1]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=1]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=2]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=2]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=3]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=3]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=4]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=4]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=5]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=5]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=6]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=6]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=7]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=7]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=8]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=8]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=9]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=9]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=10]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=10]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=11]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=11]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=12]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=12]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=13]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=13]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=14]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=14]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=15]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=15]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=16]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=16]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=17]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=17]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=18]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=18]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=19]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=19]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=20]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=20]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=21]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=21]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=22]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=22]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=23]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=23]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=24]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=24]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=25]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=25]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=26]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=26]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=27]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=27]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=28]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=28]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=29]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=29]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=30]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=30]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=31]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=2 and Day=31]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=1]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=1]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=2]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=2]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=3]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=3]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=4]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=4]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=5]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=5]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=6]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=6]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=7]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=7]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=8]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=8]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=9]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=9]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=10]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=10]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=11]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=11]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=12]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=12]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=13]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=13]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=14]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=14]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=15]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=15]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=16]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=16]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=17]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=17]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=18]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=18]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=19]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=19]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=20]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=20]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=21]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=21]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=22]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=22]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=23]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=23]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=24]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=24]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=25]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=25]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=26]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=26]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=27]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=27]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=28]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=28]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=29]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=29]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=30]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=30]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>
<Cell><Data ss:Type="Number"><xsl:choose><xsl:when test="Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=31]"><xsl:value-of select="format-number(Accumulation/DailyAccumulations/DailyAccumulation[Month=3 and Day=31]/Value,'#,###,##0.00')"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></Data></Cell>

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
	<xsl:template match="ExtractHost" mode="i777">
		
		<xsl:variable name="totalTips" select="sum(Accumulation/Compensations[PayType/Id=3]/Amount)"/>
		<xsl:variable name="fitWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=1]/TaxableWage"/>
		<xsl:variable name="totalSSWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=4]/TaxableWage"/>

		<xsl:variable name="totalMDWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=2]/TaxableWage"/>
		<xsl:variable name="totalFITTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=1]/Amount"/>
		<xsl:variable name="totalSSTax" select="(Accumulation/Taxes/PayrollTax[Tax/Id=4]/Amount + Accumulation/Taxes/PayrollTax[Tax/Id=5]/Amount)"/>
		<xsl:variable name="totalMDTax" select="(Accumulation/Taxes/PayrollTax[Tax/Id=2]/Amount + Accumulation/Taxes/PayrollTax[Tax/Id=3]/Amount)"/>


		
		<xsl:variable name="line11" select="($totalFITTax + $totalSSTax + $totalMDTax)"/>
		
			
			<Row>
				<Cell><Data ss:Type="String"><xsl:value-of select="HostCompany/FederalEIN"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($fitWages,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalFITTax,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalSSWages,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalTips,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($totalMDWages,'#,###,##0.00')"/></Data></Cell>
				<Cell><Data ss:Type="String"></Data></Cell>
				<Cell><Data ss:Type="Number"><xsl:value-of select="format-number($line11,'#,###,##0.00')"/></Data></Cell>
			</Row>
		
	</xsl:template>




</xsl:stylesheet>