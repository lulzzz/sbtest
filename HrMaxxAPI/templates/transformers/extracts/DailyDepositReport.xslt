<xsl:stylesheet version="1.0" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="urn:my-scripts" xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:fn="http://exslt.org/math">

	<xsl:param name="today"/>
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
				<Style ss:ID="s68">
					<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
					 ss:Bold="1"/>
				</Style>
				<Style ss:ID="s69">
					<Alignment ss:Vertical="Bottom"/>
				</Style>
				<Style ss:ID="s71">
					<Alignment ss:Vertical="Bottom"/>
				</Style>
				<Style ss:ID="s72">
					<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
					 ss:Bold="1"/>
				</Style>
				<Style ss:ID="s73">
					<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
					 ss:Bold="1"/>
				</Style>
				<Style ss:ID="s62">
					<NumberFormat ss:Format="&quot;$&quot;#,##0.00"/>
				</Style>
			</Styles>
			<xsl:apply-templates />
		</Workbook>
	</xsl:template>
	<xsl:template match="ExtractResponse">
		<Worksheet ss:Name="Check Deposits">
			<Table >
				<Column ss:AutoFitWidth="0" ss:Width="75"/>
				<Column ss:AutoFitWidth="0" ss:Width="207.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="117.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="124.5"/>
				<Row ss:Height="18.75">
					<Cell ss:MergeAcross="3" ss:StyleID="s68">
						<Data ss:Type="String">Deposit Slip</Data>
					</Cell>
					<Cell ss:StyleID="s72"/>
					<Cell ss:StyleID="s72"/>
				</Row>
				
				<xsl:apply-templates select="/ExtractResponse/Hosts/ExtractHost" mode="check"/>
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
		<Worksheet ss:Name="Cash Deposits">
			<Table >
				<Column ss:AutoFitWidth="0" ss:Width="75"/>
				<Column ss:AutoFitWidth="0" ss:Width="207.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="117.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="124.5"/>
				<Row ss:Height="18.75">
					<Cell ss:MergeAcross="3" ss:StyleID="s68">
						<Data ss:Type="String">Deposit Slip</Data>
					</Cell>
					<Cell ss:StyleID="s72"/>
					<Cell ss:StyleID="s72"/>
				</Row>

				<xsl:apply-templates select="/ExtractResponse/Hosts/ExtractHost" mode="cash"/>
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
		<Worksheet ss:Name="ACH Deposits">
			<Table >
				<Column ss:AutoFitWidth="0" ss:Width="75"/>
				<Column ss:AutoFitWidth="0" ss:Width="207.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="117.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="124.5"/>
				<Row ss:Height="18.75">
					<Cell ss:MergeAcross="3" ss:StyleID="s68">
						<Data ss:Type="String">Deposit Slip</Data>
					</Cell>
					<Cell ss:StyleID="s72"/>
					<Cell ss:StyleID="s72"/>
				</Row>

				<xsl:apply-templates select="/ExtractResponse/Hosts/ExtractHost" mode="ach"/>
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
	<xsl:template match="ExtractCompany" mode="check">
		<xsl:apply-templates select="Payments/ExtractInvoicePayment[Method='Check']" mode="check"/>
	</xsl:template>
	<xsl:template match="ExtractCompany" mode="ach">
		<xsl:apply-templates select="Payments/ExtractInvoicePayment[Method='ACH']" mode="ach"/>
	</xsl:template>
	<xsl:template match="ExtractCompany" mode="cash">
		<xsl:variable name="compPosition" select="count(preceding-sibling::ExtractCompany[Payments/ExtractInvoicePayment[Method='Cash' or Method='CorpFund' or Method='CertFund']])"/>
		
			<xsl:variable name="cashRow" select="sum(Payments/ExtractInvoicePayment[Method='Cash'  or Method='CorpFund' or Method='CertFund']/Amount)"/>
			<Row>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="$compPosition + 1"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="Company/TaxFilingName"/>
					</Data>
				</Cell>
				<Cell >
					<Data ss:Type="String">Cash</Data>
				</Cell>
				<Cell ss:StyleID="s62">
					<Data ss:Type="Number">
						<xsl:value-of select="$cashRow"/>
					</Data>
				</Cell>
			</Row>
		
	</xsl:template>
	<xsl:template match="ExtractInvoicePayment" mode="check">
		<xsl:variable name="starter" select="count(../../preceding-sibling::ExtractCompany/Payments/ExtractInvoicePayment[Method='Check'])"/>
		<Row>
			<Cell>
				<Data ss:Type="Number">
					<xsl:value-of select="$starter + position()"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="../../Company/TaxFilingName"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="Number">
					<xsl:value-of select="CheckNumber"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s62">
				<Data ss:Type="Number">
					<xsl:value-of select="Amount"/>
				</Data>
			</Cell>
		</Row>
	</xsl:template>
	<xsl:template match="ExtractInvoicePayment" mode="ach">
		<xsl:variable name="starter" select="count(../../preceding-sibling::ExtractCompany/Payments/ExtractInvoicePayment[Method='ACH'])"/>
		<Row>
			<Cell>
				<Data ss:Type="Number">
					<xsl:value-of select="$starter + position()"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="../../Company/TaxFilingName"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="Number">
					<xsl:value-of select="CheckNumber"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s62">
				<Data ss:Type="Number">
					<xsl:value-of select="Amount"/>
				</Data>
			</Cell>
		</Row>
	</xsl:template>
	<xsl:template match="ExtractHost" mode="check">
		<Row>
			<Cell ss:MergeAcross="3" ss:StyleID="s69">
				<Data ss:Type="String">
					<xsl:value-of select="concat(Host/FirmName, '                                                 Date:',$today)"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s71"/>
			<Cell ss:StyleID="s71"/>
		</Row>
		<Row>
			<Cell ss:MergeAcross="3" ss:StyleID="s69">
			</Cell>
			<Cell ss:StyleID="s71"/>
			<Cell ss:StyleID="s71"/>
		</Row>
		<Row>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Index</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Company</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Check #</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Amount</Data>
			</Cell>
		</Row>
		<xsl:apply-templates select="Companies/ExtractCompany[count(Payments/ExtractInvoicePayment[Method='Check'])>0]" mode="check"/>
	</xsl:template>
	<xsl:template match="ExtractHost" mode="cash">
		<Row>
			<Cell ss:MergeAcross="3" ss:StyleID="s69">
				<Data ss:Type="String">
					<xsl:value-of select="concat(Host/FirmName, '                                                 Date:',$today)"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s71"/>
			<Cell ss:StyleID="s71"/>
		</Row>
		<Row>
			<Cell ss:MergeAcross="3" ss:StyleID="s69">
			</Cell>
			<Cell ss:StyleID="s71"/>
			<Cell ss:StyleID="s71"/>
		</Row>
		<Row>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Index</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Company</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Check #</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Amount</Data>
			</Cell>
		</Row>
		<xsl:apply-templates select="Companies/ExtractCompany[count(Payments/ExtractInvoicePayment[Method='Cash' or Method='CertFund' or Method='CorpCheck'])>0]" mode="cash"/>
	</xsl:template>
	<xsl:template match="ExtractHost" mode="ach">
		<Row>
			<Cell ss:MergeAcross="3" ss:StyleID="s69">
				<Data ss:Type="String">
					<xsl:value-of select="concat(Host/FirmName, '                                                 Date:',$today)"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s71"/>
			<Cell ss:StyleID="s71"/>
		</Row>
		<Row>
			<Cell ss:MergeAcross="3" ss:StyleID="s69">
			</Cell>
			<Cell ss:StyleID="s71"/>
			<Cell ss:StyleID="s71"/>
		</Row>
		<Row>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Index</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Company</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Check #</Data>
			</Cell>
			<Cell ss:StyleID="s73">
				<Data ss:Type="String">Amount</Data>
			</Cell>
		</Row>
		<xsl:apply-templates select="Companies/ExtractCompany[count(Payments/ExtractInvoicePayment[Method='ACH'])>0]" mode="cash"/>
	</xsl:template>
</xsl:stylesheet>