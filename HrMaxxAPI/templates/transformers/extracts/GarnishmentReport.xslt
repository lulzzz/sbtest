<xsl:stylesheet version="1.0" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="urn:my-scripts" xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:fn="http://exslt.org/math">
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
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
					<Interior/>
					<NumberFormat/>
					<Protection/>
				</Style>
				<Style ss:ID="s62">
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
					 ss:Bold="1"/>
					<Interior ss:Color="#D0CECE" ss:Pattern="Solid"/>
				</Style>
				<Style ss:ID="s63">
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
					 ss:Bold="1"/>
					<Interior ss:Color="#D0CECE" ss:Pattern="Solid"/>
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00;[Red]&quot;$&quot;#,##0.00"/>
				</Style>
				<Style ss:ID="s64">
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00;[Red]&quot;$&quot;#,##0.00"/>
				</Style>
			</Styles>
			<xsl:apply-templates />
		</Workbook>
	</xsl:template>
	<xsl:template match="ExtractResponse">
		<Worksheet ss:Name="Garnishments">

			<Table x:FullColumns="1"
			 x:FullRows="1" ss:DefaultRowHeight="15">
				<Column ss:AutoFitWidth="0" ss:Width="345"/>
				<Column ss:AutoFitWidth="0" ss:Width="200"/>
				<Column ss:AutoFitWidth="0" ss:Width="84"/>
				<Column ss:AutoFitWidth="0" ss:Width="200"/>
		<xsl:apply-templates select="Hosts/ExtractHost[count(Accumulation/GarnishmentAgencies/GarnishmentAgency/Accounts/GarnishmentAgencyAccount)>0]"/>
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
						<ActiveRow>1</ActiveRow>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
	</xsl:template>
	<xsl:template match="ExtractHost">

		<Row ss:AutoFitHeight="0">
			<Cell ss:StyleID="s62">
				<Data ss:Type="String">
					<xsl:value-of select="Host/FirmName"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s62">
				<Data ss:Type="String"></Data>
			</Cell>
			<Cell ss:StyleID="s62">
				<Data ss:Type="String"></Data>
			</Cell>
			<Cell ss:StyleID="s63">
				<Data ss:Type="String"></Data>
			</Cell>
		</Row>
	<Row ss:AutoFitHeight="0">
		<Cell ss:StyleID="s62">
			<Data ss:Type="String">Agency</Data>
		</Cell>
		<Cell ss:StyleID="s62">
			<Data ss:Type="String">Deduction</Data>
		</Cell>
		<Cell ss:StyleID="s62">
			<Data ss:Type="String">Exp No</Data>
		</Cell>
		<Cell ss:StyleID="s63">
			<Data ss:Type="String">Amount</Data>
		</Cell>
	</Row>
	<xsl:apply-templates select="Accumulation/GarnishmentAgencies/GarnishmentAgency/Accounts/GarnishmentAgencyAccount"/>
	<Row ss:AutoFitHeight="0">
		<Cell ss:StyleID="s62">
			<Data ss:Type="String">
							
			</Data>
		</Cell>
		<Cell ss:StyleID="s62">
			<Data ss:Type="String">
							
			</Data>
		</Cell>
		<Cell ss:StyleID="s62">
			<Data ss:Type="String">
				Total
			</Data>
		</Cell>
		<Cell ss:StyleID="s63">
			<Data ss:Type="Number">
				<xsl:value-of select="sum(Accumulation/GarnishmentAgencies/GarnishmentAgency/Accounts/GarnishmentAgencyAccount/Amount)"/>
			</Data>
		</Cell>
	</Row>
			
	</xsl:template>
	<xsl:template match="GarnishmentAgencyAccount">
		<Row>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="../../Agency/Name"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="Deduction"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="AccountNo"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="Number">
					<xsl:value-of select="Amount"/>
				</Data>
			</Cell>
		</Row>
	</xsl:template>
</xsl:stylesheet>