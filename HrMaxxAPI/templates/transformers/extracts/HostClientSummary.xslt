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
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00;[Red]&quot;$&quot;#,##0.00"/>
				</Style>
				<Style ss:ID="s63">
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
					 ss:Bold="1"/>
					<Interior ss:Color="#D0CECE" ss:Pattern="Solid"/>
				</Style>
				<Style ss:ID="s68">
					<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
					 ss:Bold="1"/>
					<Interior ss:Color="#D0CECE" ss:Pattern="Solid"/>
				</Style>
				<Style ss:ID="s69">
					<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
					 ss:Bold="1"/>
					<Interior ss:Color="#D0CECE" ss:Pattern="Solid"/>
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00;[Red]&quot;$&quot;#,##0.00"/>
				</Style>
				<Style ss:ID="s70">
					<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
				</Style>
				<Style ss:ID="s71">
					<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
					 ss:Bold="1"/>
					<Interior ss:Color="#D0CECE" ss:Pattern="Solid"/>
					<NumberFormat ss:Format="Fixed"/>
				</Style>
				<Style ss:ID="s72">
					<NumberFormat ss:Format="Fixed"/>
				</Style>
				<Style ss:ID="s74">
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00"/>
				</Style>
				<Style ss:ID="s75">
					<NumberFormat ss:Format="m/d/yyyy;@"/>
				</Style>
			</Styles>
			<xsl:apply-templates />
		</Workbook>
	</xsl:template>
	<xsl:template match="ExtractResponse">
		<Worksheet ss:Name="Totals">
			<Table x:FullColumns="1"
			 x:FullRows="1" ss:DefaultRowHeight="15">
				<Column ss:Width="195.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="77.25"/>
				<Column ss:Width="306.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="104.25"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="93.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="72.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="69.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="68.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="70.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="75"/>
				<Row ss:AutoFitHeight="0" ss:StyleID="s70">
					<Cell ss:StyleID="s68">
						<Data ss:Type="String">Host</Data>
					</Cell>
					<Cell ss:StyleID="s71">
						<Data ss:Type="String">Company No</Data>
					</Cell>
					<Cell ss:StyleID="s68">
						<Data ss:Type="String">Company</Data>
					</Cell>
					<Cell ss:StyleID="s68">
						<Data ss:Type="String">EIN</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total Gross</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total 941</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total 940</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total UI</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total ETT</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total Federal</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total State(CA)</Data>
					</Cell>
				</Row>
				<xsl:apply-templates select="Hosts/ExtractHost/Companies/ExtractCompany" mode="Totals">
					<xsl:sort select="../../Host/FirmName" data-type="text"/>
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
						<ActiveRow>1</ActiveRow>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
		<Worksheet ss:Name="Company Payrolls">
			<Table x:FullColumns="1"
			 x:FullRows="1" ss:DefaultRowHeight="15">
				<Column ss:Width="195.75"/>
				<Column ss:Width="64.5"/>
				<Column ss:Width="306"/>
				<Column ss:AutoFitWidth="0" ss:Width="90"/>
				<Column ss:AutoFitWidth="0" ss:Width="85.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="168"/>
				<Column ss:AutoFitWidth="0" ss:Width="81"/>
				<Column ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:AutoFitWidth="0" ss:Width="89.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="66.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="62.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="57"/>
				<Column ss:AutoFitWidth="0" ss:Width="57.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="81" ss:Span="1"/>
				<Row ss:AutoFitHeight="0">
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Host</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Company No</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Company</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">EIN</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Start Period</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">End Period</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Pay Day</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Tax Pay Day</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Gross Wage</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">941</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">940</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">UI</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">ETT</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Federal Taxes</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">State (CA) Taxes</Data>
					</Cell>
				</Row>
				<xsl:apply-templates select="Hosts/ExtractHost/Companies/ExtractCompany" mode="WC"/>
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
	<xsl:template match="ExtractCompany" mode="Totals">
		<xsl:variable name="host" select="../.."/>
		<xsl:variable name ="comp" select="Company"/>
		<xsl:variable name ="totalGross" select="sum(Summaries/PayrollSummary/GrossWage)"/>
		<xsl:variable name ="total941" select="sum(Summaries/PayrollSummary/Total941)"/>
		<xsl:variable name ="total940" select="sum(Summaries/PayrollSummary/Total940)"/>
		<xsl:variable name ="totalUi" select="sum(Summaries/PayrollSummary/TotalUi)"/>
		<xsl:variable name ="totalEtt" select="sum(Summaries/PayrollSummary/TotalEtt)"/>
		<xsl:variable name ="totalFederal" select="sum(Summaries/PayrollSummary/TotalFederal)"/>
		<xsl:variable name ="totalState" select="sum(Summaries/PayrollSummary/TotalState)"/>
		<Row>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="$host/Host/FirmName"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="Number">
					<xsl:value-of select="$comp/CompanyNo" />
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="translate($comp/TaxFilingName,$smallcase,$uppercase)" />
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="concat(substring($comp/FederalEIN,1,2),'-',substring($comp/FederalEIN,3,7))"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="$totalGross"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="$total941"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="$total940"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="$totalUi"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="$totalEtt"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="$totalFederal"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="$totalState"/>
				</Data>
			</Cell>
			
		</Row>
		
	</xsl:template>
	<xsl:template match="ExtractCompany" mode="WC">
		
		<xsl:apply-templates select="Summaries/PayrollSummary">
			<xsl:sort select="StartDate"/>
		</xsl:apply-templates>
		
	</xsl:template>
	<xsl:template match="PayrollSummary">
		<xsl:variable name="host" select="../../../.."/>
		<xsl:variable name ="comp" select="../../Company"/>
		<Row>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="$host/Host/FirmName"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="Number">
					<xsl:value-of select="$comp/CompanyNo"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="$comp/TaxFilingName"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="concat(substring($comp/FederalEIN,1,2),'-',substring($comp/FederalEIN,3,7))"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="msxsl:format-date(StartDate, 'MM/dd/yyyy')"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="msxsl:format-date(EndDate, 'MM/dd/yyyy')"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="msxsl:format-date(PayDay, 'MM/dd/yyyy')"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="msxsl:format-date(TaxPayDay, 'MM/dd/yyyy')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="GrossWage"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="Total941"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="Total940"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="TotalUi"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="TotalEtt"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="TotalFederal"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="TotalState"/>
				</Data>
			</Cell>
		</Row>
	</xsl:template>
</xsl:stylesheet>