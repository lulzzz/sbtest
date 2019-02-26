<xsl:stylesheet version="1.0" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="urn:my-scripts" xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:fn="http://exslt.org/math">
	<xsl:param name="selectedYear" />
	<xsl:param name="todaydate" />
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
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
					<Font ss:FontName="Arial"/>
					<Interior/>
					<NumberFormat/>
					<Protection/>
				</Style>
				<Style ss:ID="s54" ss:Name="Hyperlink">
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#0000FF"
					 ss:Underline="Single"/>
				</Style>
				<Style ss:ID="s64">
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
					<NumberFormat ss:Format="Fixed"/>
				</Style>
				<Style ss:ID="s68">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<NumberFormat ss:Format="Fixed"/>
				</Style>
				<Style ss:ID="s69" ss:Parent="s54">
					<Alignment ss:Vertical="Bottom"/>
					<Protection/>
				</Style>
				<Style ss:ID="s70">
					<NumberFormat ss:Format="@"/>
				</Style>
				<Style ss:ID="s71">
					<Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<Interior/>
					<NumberFormat ss:Format="00000"/>
				</Style>
				<Style ss:ID="s72">
					<NumberFormat ss:Format="#,##0.00_);\(#,##0.00\)"/>
				</Style>
				<Style ss:ID="s73">
					<NumberFormat
					 ss:Format="_(* #,##0.000000_);_(* \(#,##0.000000\);_(* &quot;-&quot;??????_);_(@_)"/>
				</Style>
				<Style ss:ID="s74">
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
				</Style>
				<Style ss:ID="s75">
					<Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat ss:Format="#,##0.00_);\(#,##0.00\)"/>
				</Style>
				<Style ss:ID="s76">
					<Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<Interior/>
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
				</Style>
				<Style ss:ID="s77">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat ss:Format="@"/>
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
					<NumberFormat ss:Format="@"/>
				</Style>
				<Style ss:ID="s79">
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
				<Style ss:ID="s80">
					<Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat ss:Format="m/d/yyyy;@"/>
				</Style>
				<Style ss:ID="s81">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat ss:Format="m/d/yyyy;@"/>
				</Style>
				<Style ss:ID="s82">
					<NumberFormat ss:Format="m/d/yyyy;@"/>
				</Style>
				<Style ss:ID="s83">
					<Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30"
					 ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat ss:Format="@"/>
				</Style>
				<Style ss:ID="s84">
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
				<Style ss:ID="s85">
					<Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
				</Style>
				<Style ss:ID="s86">
					<Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<Interior/>
					<NumberFormat ss:Format="@"/>
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
					<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
					<NumberFormat ss:Format="00000"/>
				</Style>
				<Style ss:ID="s88">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
				</Style>
				<Style ss:ID="s89">
					<Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30"
					 ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat ss:Format="00000"/>
				</Style>
				<Style ss:ID="s90">
					<Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight" ss:Rotate="30"
					 ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat ss:Format="00000"/>
				</Style>
				<Style ss:ID="s91">
					<Interior/>
					<NumberFormat/>
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
					<Interior/>
					<NumberFormat/>
				</Style>
				<Style ss:ID="s93">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<Interior/>
					<NumberFormat/>
				</Style>
				<Style ss:ID="s94">
					<NumberFormat ss:Format="Currency"/>
				</Style>
				<Style ss:ID="s95">
					<Font ss:FontName="Arial" x:Family="Swiss"/>
				</Style>
				<Style ss:ID="s96">
					<Font ss:FontName="Arial" x:Family="Swiss"/>
					<NumberFormat ss:Format="@"/>
				</Style>
				<Style ss:ID="s97">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat/>
				</Style>
				<Style ss:ID="s98">
					<Interior/>
				</Style>
				<Style ss:ID="s99">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
				</Style>
				<Style ss:ID="s100">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Interior/>
				</Style>
				<Style ss:ID="s101">
					<Interior/>
					<NumberFormat ss:Format="Currency"/>
				</Style>
				<Style ss:ID="s102">
					<Interior/>
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
				</Style>
				<Style ss:ID="s103">
					<Font ss:FontName="Arial" x:Family="Swiss"/>
					<Interior/>
					<NumberFormat ss:Format="Currency"/>
				</Style>
				<Style ss:ID="s104">
					<Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat/>
				</Style>
				<Style ss:ID="s105">
					<Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat/>
				</Style>
				<Style ss:ID="s106">
					<Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
					<NumberFormat/>
				</Style>
				<Style ss:ID="s107">
					<Alignment ss:Vertical="Center" ss:ReadingOrder="LeftToRight"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<NumberFormat/>
				</Style>
				<Style ss:ID="s108">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<NumberFormat/>
				</Style>
				<Style ss:ID="s109">
					<NumberFormat/>
				</Style>
				<Style ss:ID="s110">
					<Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
					<Interior/>
					<NumberFormat
					 ss:Format="_(* #,##0.000000_);_(* \(#,##0.000000\);_(* &quot;-&quot;??????_);_(@_)"/>
				</Style>
				<Style ss:ID="s111">
					<Alignment ss:Vertical="Center" ss:Rotate="30" ss:WrapText="1"/>
					<Borders>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Arial" x:Family="Swiss"/>
					<Interior/>
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00_);\(&quot;$&quot;#,##0.00\)"/>
				</Style>
				<Style ss:ID="s112">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<NumberFormat ss:Format="@"/>
				</Style>
				<Style ss:ID="s113">
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
				<Style ss:ID="s114">
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
				<Style ss:ID="s115">
					<Alignment ss:Vertical="Bottom" ss:Rotate="45"/>
				</Style>
			</Styles>
			<xsl:apply-templates />
		</Workbook>
	</xsl:template>
	<xsl:template match="ExtractResponse">
		<Worksheet ss:Name="Company Information">
			<Table x:FullColumns="1" x:FullRows="1">
				<Column ss:StyleID="s70" ss:Width="52.5"/>
				<Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="80.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="96.75"/>
				<Column ss:Index="7" ss:AutoFitWidth="0" ss:Width="64.5"/>
				<Column ss:Index="9" ss:StyleID="s70" ss:AutoFitWidth="0" ss:Width="46.5"/>
				<Column ss:Index="14" ss:StyleID="s70" ss:Width="57.75"/>
				<Column ss:Index="17" ss:StyleID="s82" ss:Width="53.25"/>
				<Column ss:Index="19" ss:StyleID="s70" ss:Width="52.5" ss:Span="1"/>
				<Column ss:Index="22" ss:StyleID="s98" ss:AutoFitWidth="0"/>
				<Row ss:AutoFitHeight="0" ss:Height="66" ss:StyleID="s115">
					<Cell ss:StyleID="s79">
						<Data ss:Type="String">EIN </Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Name Control</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Business Name 1</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Business Name 2</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Address 1</Data>
					</Cell>
					<Cell ss:StyleID="s113">
						<Data ss:Type="String">Do Not Use</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">City</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">State</Data>
					</Cell>
					<Cell ss:StyleID="s79">
						<Data ss:Type="String">Zip Code</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Agent Name</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Agent Title</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Contact Name</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Contact Title</Data>
					</Cell>
					<Cell ss:StyleID="s79">
						<Data ss:Type="String">Phone Number</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">e-Mail Address</Data>
					</Cell>
					<Cell ss:StyleID="s66">
						<Data ss:Type="String">Signature Name</Data>
					</Cell>
					<Cell ss:StyleID="s80">
						<Data ss:Type="String">Signature Date</Data>
					</Cell>
					<Cell ss:StyleID="s67">
						<Data ss:Type="String">Account Type</Data>
					</Cell>
					<Cell ss:StyleID="s79">
						<Data ss:Type="String">Routing Number</Data>
					</Cell>
					<Cell ss:StyleID="s79">
						<Data ss:Type="String">Account Number</Data>
					</Cell>
					<Cell ss:StyleID="s67">
						<Data ss:Type="String">Online PIN (For Indirect Filers Only)</Data>
					</Cell>
					<Cell ss:StyleID="s114">
						<Data ss:Type="String">Address Change - Not Necessary in V2.1</Data>
					</Cell>
				</Row>
				<Row>
					<Cell ss:StyleID="s77">
						<Data ss:Type="String">QEX 2.X</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65"/>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s77">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s77">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s65">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s81">
						<Data ss:Type="String">R</Data>
					</Cell>
					<Cell ss:StyleID="s68">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s112"/>
					<Cell ss:StyleID="s112"/>
					<Cell ss:StyleID="s99"/>
					<Cell ss:StyleID="s100"/>
				</Row>
				<Row></Row>
				<xsl:apply-templates select="Hosts/ExtractHost[count(PayCheckAccumulation/PayCheckList/PayCheckSummary)>0]" mode="CompanyInfo">
					<xsl:sort select="HostCompany/TaxFilingName"/>
				</xsl:apply-templates>
				
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<Print>
					<ValidPrinterInfo />
					<HorizontalResolution>200</HorizontalResolution>
					<VerticalResolution>200</VerticalResolution>
				</Print>
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>2</ActiveRow>
						<RangeSelection>R3</RangeSelection>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
		<Worksheet ss:Name="940 Return Information">
			<Table x:FullColumns="1" x:FullRows="1">
				<Column ss:StyleID="s70" ss:AutoFitWidth="0" ss:Width="73.5"/>
				<Column ss:StyleID="s70" ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:AutoFitWidth="0" ss:Width="83.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="115.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="125.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="105"/>
				<Column ss:AutoFitWidth="0" ss:Width="68.25"/>
				<Column ss:StyleID="s74" ss:Width="61.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="85.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="73.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="82.5"/>
				<Column ss:StyleID="s70" ss:AutoFitWidth="0" ss:Width="63"/>
				<Column ss:StyleID="s72" ss:AutoFitWidth="0" ss:Width="75"/>
				<Column ss:StyleID="s70" ss:AutoFitWidth="0" ss:Width="79.5"/>
				<Column ss:StyleID="s72" ss:AutoFitWidth="0" ss:Width="66.75"/>
				<Column ss:StyleID="s70" ss:AutoFitWidth="0" ss:Width="77.25"/>
				<Column ss:StyleID="s91" ss:AutoFitWidth="0" ss:Width="110.25"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="114.75"/>
				<Column ss:StyleID="s102" ss:AutoFitWidth="0" ss:Width="110.25"/>
				<Column ss:StyleID="s102" ss:AutoFitWidth="0" ss:Width="126.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="87.75"/>
				<Column ss:StyleID="s74" ss:Span="1"/>
				<Column ss:Index="24" ss:StyleID="s74" ss:Width="56.25"/>
				<Column ss:StyleID="s74"/>
				<Column ss:StyleID="s70" ss:AutoFitWidth="0" ss:Width="81.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="111.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="78"/>
				<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="75.75"/>
				<Column ss:StyleID="s70" ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="81"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="90"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="57.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="79.5"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="91.5"/>
				<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="60"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="96"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="64.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="89.25"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="84.75"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="91.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="99.75"/>
				<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="77.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="74.25"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="81"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="81.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="85.5"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="71.25"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="96"/>
				<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="55.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="70.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="89.25"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="78.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="97.5"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="79.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="93"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="74.25"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="90"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="105"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="85.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="99.75"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="72"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="91.5"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="84"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="73.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="97.5"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="84.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="81.75"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="87.75"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="76.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="85.5"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="85.5" ss:Span="1"/>
				<Column ss:Index="117" ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="73.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="90"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="78"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="94.5"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="78.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="85.5"/>
				<Column ss:StyleID="s73"/>
				<Column ss:AutoFitWidth="0" ss:Width="48"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="81"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="81.75"/>
				<Column ss:StyleID="s73"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="51.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="82.5"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="75.75"/>
				<Column ss:StyleID="s74" ss:AutoFitWidth="0"/>
				<Column ss:Index="139" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
				<Column ss:Index="143" ss:AutoFitWidth="0" ss:Width="83.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="75"/>
				<Column ss:Index="147" ss:AutoFitWidth="0" ss:Width="87.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="74.25"/>
				<Column ss:Index="151" ss:AutoFitWidth="0" ss:Width="88.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="83.25"/>
				<Column ss:Index="155" ss:AutoFitWidth="0" ss:Width="90"/>
				<Column ss:AutoFitWidth="0" ss:Width="94.5"/>
				<Column ss:Index="159" ss:AutoFitWidth="0" ss:Width="79.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="82.5"/>
				<Column ss:Index="163" ss:AutoFitWidth="0" ss:Width="87.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:Index="167" ss:AutoFitWidth="0" ss:Width="83.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="86.25"/>
				<Column ss:Index="171" ss:AutoFitWidth="0" ss:Width="84.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="78.75"/>
				<Column ss:Index="175" ss:AutoFitWidth="0" ss:Width="92.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="91.5"/>
				<Column ss:Index="179" ss:AutoFitWidth="0" ss:Width="83.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="77.25"/>
				<Column ss:Index="183" ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:AutoFitWidth="0" ss:Width="97.5"/>
				<Column ss:Index="187" ss:AutoFitWidth="0" ss:Width="88.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="94.5"/>
				<Column ss:Index="191" ss:AutoFitWidth="0" ss:Width="91.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="84.75"/>
				<Column ss:Index="195" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="79.5"/>
				<Column ss:Index="199" ss:AutoFitWidth="0" ss:Width="84.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="99"/>
				<Column ss:AutoFitWidth="0" ss:Width="84"/>
				<Column ss:Index="203" ss:AutoFitWidth="0" ss:Width="80.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="82.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="60.75"/>
				<Column ss:Index="207" ss:AutoFitWidth="0" ss:Width="93"/>
				<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
				<Column ss:Index="211" ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:AutoFitWidth="0" ss:Width="87.75"/>
				<Column ss:Index="215" ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:AutoFitWidth="0" ss:Width="88.5"/>
				<Column ss:Index="219" ss:AutoFitWidth="0" ss:Width="83.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="96"/>
				<Column ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:Index="223" ss:AutoFitWidth="0" ss:Width="83.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
				<Column ss:Index="227" ss:AutoFitWidth="0" ss:Width="92.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="98.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="72.75"/>
				<Row ss:AutoFitHeight="0" ss:Height="63.75">
					<Cell ss:StyleID="s83">
						<Data ss:Type="String">EIN (EIN wihhout dashes)</Data>
					</Cell>
					<Cell ss:StyleID="s83">
						<Data ss:Type="String">Year of Return (YYYY)</Data>
					</Cell>
					<Cell ss:StyleID="s89">
						<Data ss:Type="String">Single State Filer (Yes for Single State, No for Multi State)</Data>
					</Cell>
					<Cell ss:StyleID="s87">
						<Data ss:Type="String">Is ANY your FUTA tax excluded from State Unemployment Tax? (Y for Yes or N for No)</Data>
					</Cell>
					<Cell ss:StyleID="s90">
						<Data ss:Type="String">Is ALL of your FUTA tax excluded from State unemployment Tax? (Y for Yes or N for No)</Data>
					</Cell>
					<Cell ss:StyleID="s64">
						<Data ss:Type="String">Final Return (Y for Yes, N for No)</Data>
					</Cell>
					<Cell ss:StyleID="s64">
						<Data ss:Type="String">No Payments (Y for Yes, N for No)</Data>
					</Cell>
					<Cell ss:StyleID="s84">
						<Data ss:Type="String">Total Payments (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s84">
						<Data ss:Type="String">State Contributions Paid on Time (All States) (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s85">
						<Data ss:Type="String">State Contributions Paid Late (All States) (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s85">
						<Data ss:Type="String">Payments Exempt from FUTA Tax (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s78">
						<Data ss:Type="String">Fringe Benefits (Y for Yes, N or Blank for No)</Data>
					</Cell>
					<Cell ss:StyleID="s75">
						<Data ss:Type="String">Group Term Life Insurance ( Y for Yes, N or Blank for No)</Data>
					</Cell>
					<Cell ss:StyleID="s78">
						<Data ss:Type="String">Retirement/Pension (Y for Yes, N or Blank for No)</Data>
					</Cell>
					<Cell ss:StyleID="s75">
						<Data ss:Type="String">Dependent Care (Y for Yes, N or Blank for No)</Data>
					</Cell>
					<Cell ss:StyleID="s78">
						<Data ss:Type="String">Other ( Y for Yes, N or Blank for No)</Data>
					</Cell>
					<Cell ss:StyleID="s92">
						<Data ss:Type="String">Refund or Apply Overpayment (R for Refund and A for Apply)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Payments Made to Each Employee in excess of $7000 (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s111">
						<Data ss:Type="String">Return Type (Regular 940 if blank)</Data>
					</Cell>
					<Cell ss:StyleID="s111">
						<Data ss:Type="String">Blank</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Tax Deposits (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Quarter 1 Liability (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Quarter 2 Liability (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Quarter 3 Liability (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Quarter 4 Liability (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s86">
						<Data ss:Type="String">State Abbreviation 1  (Two Character Abbreviation)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State (All States combined = Line 7 on 940)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s86">
						<Data ss:Type="String">State Abbreviation 2</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 3</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 4</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 5</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 6</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 7</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 8</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 9</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 10</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 11</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 12</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 13</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 14</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s110">
						<Data ss:Type="String">BLANK</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 15</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 16</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 17</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 18</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 19</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 20</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 21</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 22</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 23</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 24</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 25</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 26</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 27</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 28</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 29</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s110">
						<Data ss:Type="String">BLANK</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 30</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 31</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 32</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 33</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 34</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 35</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 36</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 37</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 38</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 39</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 40</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 41</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 42</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 43</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 44</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 45</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 46</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 47</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 48</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 49</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 50</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">State Abbreviation 51</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">FUTA Taxable Wages for State</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">Taxable State Unemployment Wages (Currency)</Data>
					</Cell>
					<Cell ss:StyleID="s76">
						<Data ss:Type="String">State Experience Rate - Line 10 Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
					<Cell ss:StyleID="s98"/>
				</Row>
				<Row ss:StyleID="s109">
					<Cell ss:StyleID="s104">
						<Data ss:Type="String">QEX V2.X</Data>
					</Cell>
					<Cell ss:StyleID="s104"/>
					<Cell ss:StyleID="s105">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s106">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s104">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s104">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">1</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">2</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">2</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">2</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">2</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">2</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">2</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">2</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">2</Data>
					</Cell>
					<Cell ss:StyleID="s93">
						<Data ss:Type="Number">15</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">3</Data>
					</Cell>
					<Cell ss:StyleID="s93">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s93">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="Number">13</Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s97">
						<Data ss:Type="String"> </Data>
					</Cell>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
					<Cell ss:StyleID="s108"/>
				</Row>
				<Row></Row>
				<xsl:apply-templates select="Hosts/ExtractHost[count(PayCheckAccumulation/PayCheckList/PayCheckSummary)>0]" mode="i940">
					<xsl:sort select="HostCompany/TaxFilingName"/>
				</xsl:apply-templates>
				
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<Print>
					<ValidPrinterInfo />
					<HorizontalResolution>600</HorizontalResolution>
					<VerticalResolution>600</VerticalResolution>
				</Print>
				<Selected />
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>1</ActiveRow>
						<ActiveCol>3</ActiveCol>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
	</xsl:template>
	<xsl:template match="ExtractHost" mode="CompanyInfo">
		<Row>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="concat(substring(HostCompany/FederalEIN,1,2),'-',substring(HostCompany/FederalEIN,3,7))"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="translate(substring(HostCompany/TaxFilingName,1,4),$smallcase,$uppercase)" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="translate(HostCompany/TaxFilingName,$smallcase,$uppercase)" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="translate(HostCompany/BusinessAddress/AddressLine1,$smallcase,$uppercase)"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="translate(HostCompany/BusinessAddress/City,$smallcase,$uppercase)"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="translate(States/CompanyTaxState[position()=1]/State/Abbreviation,$smallcase,$uppercase)" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="HostCompany/BusinessAddress/Zip"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="translate(Host/FirmName,$smallcase,$uppercase)"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"><xsl:value-of select="translate(concat(Contact/FirstName, ' ', Contact/LastName),$smallcase,$uppercase)"/></Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="Contact/Phone" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="$todaydate" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="translate(Host/PTIN,$smallcase,$uppercase)"/>
					</Data>
				</Cell>
			</Row>
		
	</xsl:template>
	<xsl:template match="ExtractHost" mode="i940">
		
		
			<xsl:variable name="fein1" select="translate(HostCompany/FederalEIN,'-','')" />
			<xsl:variable name="totalGrossWages" select="PayCheckAccumulation/PayCheckWages/GrossWage" />
			<xsl:variable name="totalMDWages" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage" />
			<xsl:variable name="totalFUTAWages" select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FUTA']/YTDWage" />
			<xsl:variable name="line3" select="$totalGrossWages" />
			<xsl:variable name="line4" select="$totalGrossWages - $totalMDWages" />
			<xsl:variable name="line5" select="$totalGrossWages - $line4 - $totalFUTAWages" />
			<xsl:variable name="line6" select="$line4 + $line5" />
			
			<xsl:variable name="line7" select="$totalGrossWages - $line6" />
		
			<xsl:variable name="line12a" select="format-number($line7*0.008,'####.00')" />
			<xsl:variable name="line13" select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmount,'####.00')" />
			<xsl:variable name="lineI" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTD)" />
		<xsl:variable name="firstQuarter" select="format-number(PayCheckAccumulation/PayCheckWages/Quarter1FUTAWage * PayCheckAccumulation/PayCheckWages/FUTARate div 100 , '######.00')"/>
		<xsl:variable name="secondQuarter" select="format-number(PayCheckAccumulation/PayCheckWages/Quarter2FUTAWage * PayCheckAccumulation/PayCheckWages/FUTARate div 100 , '######.00')"/>
		<xsl:variable name="thirdQuarter" select="format-number(PayCheckAccumulation/PayCheckWages/Quarter3FUTAWage * PayCheckAccumulation/PayCheckWages/FUTARate div 100 , '######.00')"/>
		<xsl:variable name="fourthQuarter" select="format-number(PayCheckAccumulation/PayCheckWages/Quarter4FUTAWage * PayCheckAccumulation/PayCheckWages/FUTARate div 100 , '######.00')"/>
			<Row>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="$fein1" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="$selectedYear" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">Y</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">N</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">N</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">N</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">N</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($line3,'#,###,##0.00')" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($lineI,'#,###,##0.00')" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($line4,'#,###,##0.00')" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:choose>
							<xsl:when test="sum(PayCheckAccumulation/Deductions/PayCheckDeduction[CompanyDeduction/R940_R='4a']/YTD)>0">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:choose>
							<xsl:when test="sum(PayCheckAccumulation/Deductions/PayCheckDeduction[CompanyDeduction/R940_R='4b']/YTD)>0">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:choose>
							<xsl:when test="sum(PayCheckAccumulation/Deductions/PayCheckDeduction[CompanyDeduction/R940_R='4c']/YTD)>0">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:choose>
							<xsl:when test="sum(PayCheckAccumulation/Deductions/PayCheckDeduction[CompanyDeduction/R940_R='4d']/YTD)>0">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:choose>
							<xsl:when test="PayCheckAccumulation/PayCheckWages/Immigrants>0">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:choose>
							<xsl:when test="$line13>$line12a">R</xsl:when>
							<xsl:when test="$line12a>$line13">A</xsl:when>
						</xsl:choose>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($line5,'#,###,##0.00')" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="String"></Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($line13,'#,###,##0.00')" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="$firstQuarter" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="$secondQuarter" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="$thirdQuarter" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="$fourthQuarter" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">CA</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($line7,'#,###,##0.00')" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($line7,'#,###,##0.00')" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">0.015</Data>
				</Cell>
			</Row>
		
	</xsl:template>
</xsl:stylesheet>