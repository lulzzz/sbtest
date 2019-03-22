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
			 <Style ss:ID="s76">
				 <Interior ss:Color="#a94442" ss:Pattern="Solid"/>
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
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="93.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="72.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="72.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="72.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="72.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="69.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="72.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="68.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="72.75"/>
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
						<Data ss:Type="String">Type</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total Gross</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total 941</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Deposit 941</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total 940</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Deposit 940</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total PIT+SDI</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Deposit PIT+SDI</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total UI+ETT</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Deposit UI+ETT</Data>
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
		<Worksheet ss:Name="Taxes">
			<Table x:FullColumns="1"
			 x:FullRows="1" ss:DefaultRowHeight="15">
				<Column ss:Width="195.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="77.25"/>
				<Column ss:Width="306.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="104.25"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="93.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="93.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
				<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="90.75"/>
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
						<Data ss:Type="String">Type</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">Total Gross</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">FIT Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">FIT</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">MD_EE Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">MD_EE</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">MD_ER Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">MD_ER</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">SS_EE Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">SS_EE</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">SS_ER Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">SS_ER</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">FUTA Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">FUTA</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">PIT Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">PIT</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">SDI Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">SDI</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">SUI Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">SUI</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">ETT Wage</Data>
					</Cell>
					<Cell ss:StyleID="s69">
						<Data ss:Type="String">ETT</Data>
					</Cell>
				</Row>
				<xsl:apply-templates select="Hosts/ExtractHost/Companies/ExtractCompany" mode="Taxes">
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
	</xsl:template>
	<xsl:template match="ExtractCompany" mode="Totals">
		<xsl:variable name="host" select="../.."/>
		<xsl:variable name ="comp" select="Company"/>
		<xsl:variable name ="totalGross" select="sum(PayCheckAccumulation/PayCheckWages/GrossWage)"/>
		<xsl:variable name ="total941" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT' or Tax/Code='MD_Employee' or Tax/Code='MD_Employer' or Tax/Code='SS_Employee' or Tax/Code='SS_Employer']/YTD)"/>
		<xsl:variable name ="total940" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FUTA']/YTD)"/>
		<xsl:variable name ="totalPit" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SIT' or Tax/Code='SDI']/YTD)"/>
		<xsl:variable name ="totalEtt" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='ETT' or Tax/Code='SUI']/YTD)"/>
		<xsl:variable name ="totalFederal" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT' or Tax/Code='MD_Employee' or Tax/Code='MD_Employer' or Tax/Code='SS_Employee' or Tax/Code='SS_Employer' or Tax/Code='FUTA']/YTD)"/>
		<xsl:variable name ="totalState" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/StateId=1]/YTD)"/>
		<Row>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="$host/Host/FirmName"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
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
				<Data ss:Type="String">
					<xsl:choose><xsl:when test="$comp/FileUnderHost='true'">PEO</xsl:when><xsl:otherwise>ASO</xsl:otherwise></xsl:choose>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number($totalGross,'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number($total941,'####.##')"/>
				</Data>
			</Cell>
			<xsl:choose>
				<xsl:when test="format-number(PayCheckAccumulation/PayCheckWages/DepositAmount941,'####.##')=format-number($total941,'####.##')">
					<Cell ss:StyleID="s74">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmount941,'####.##')"/>
						</Data>
					</Cell>
				</xsl:when>
				<xsl:otherwise>
					<Cell ss:StyleID="s76">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmount941,'####.##')"/>
						</Data>
					</Cell>
				</xsl:otherwise>
			</xsl:choose>
			
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number($total940,'####.##')"/>
				</Data>
			</Cell>
				<xsl:choose>
				<xsl:when test="format-number(PayCheckAccumulation/PayCheckWages/DepositAmount940,'####.##')=format-number($total940,'####.##')">
					<Cell ss:StyleID="s74">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmount940,'####.##')"/>
						</Data>
					</Cell>
				</xsl:when>
				<xsl:otherwise>
					<Cell ss:StyleID="s76">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmount940,'####.##')"/>
						</Data>
					</Cell>
				</xsl:otherwise>
			</xsl:choose>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number($totalPit,'####.##')"/>
				</Data>
			</Cell>
				<xsl:choose>
				<xsl:when test="format-number(PayCheckAccumulation/PayCheckWages/DepositAmountCAPIT,'####.##')=format-number($totalPit,'####.##')">
					<Cell ss:StyleID="s74">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmountCAPIT,'####.##')"/>
						</Data>
					</Cell>
				</xsl:when>
				<xsl:otherwise>
					<Cell ss:StyleID="s76">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmountCAPIT,'####.##')"/>
						</Data>
					</Cell>
				</xsl:otherwise>
			</xsl:choose>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number($totalEtt,'####.##')"/>
				</Data>
			</Cell>
				<xsl:choose>
				<xsl:when test="format-number(PayCheckAccumulation/PayCheckWages/DepositAmountCAUI,'####.##')=format-number($totalEtt,'####.##')">
					<Cell ss:StyleID="s74">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmountCAUI,'####.##')"/>
						</Data>
					</Cell>
				</xsl:when>
				<xsl:otherwise>
					<Cell ss:StyleID="s76">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(PayCheckAccumulation/PayCheckWages/DepositAmountCAUI,'####.##')"/>
						</Data>
					</Cell>
				</xsl:otherwise>
			</xsl:choose>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number($totalFederal,'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number($totalState,'####.##')"/>
				</Data>
			</Cell>
			
		</Row>
		
	</xsl:template>
	<xsl:template match="ExtractCompany" mode="Taxes">
		<xsl:variable name="host" select="../.."/>
		<xsl:variable name ="comp" select="Company"/>
		<xsl:variable name ="totalGross" select="sum(PayCheckAccumulation/PayCheckWages/GrossWage)"/>
		<xsl:variable name ="total941" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT' or Tax/Code='MD_Employee' or Tax/Code='MD_Employer' or Tax/Code='SS_Employee' or Tax/Code='SS_Employer']/YTD)"/>
		<xsl:variable name ="total940" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FUTA']/YTD)"/>
		<xsl:variable name ="totalUi" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTD)"/>
		<xsl:variable name ="totalEtt" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='ETT']/YTD)"/>
		<xsl:variable name ="totalFederal" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT' or Tax/Code='MD_Employee' or Tax/Code='MD_Employer' or Tax/Code='SS_Employee' or Tax/Code='SS_Employer' or Tax/Code='FUTA']/YTD)"/>
		<xsl:variable name ="totalState" select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/StateId=1]/YTD)"/>
		<Row>
			<Cell>
				<Data ss:Type="String">
					<xsl:value-of select="$host/Host/FirmName"/>
				</Data>
			</Cell>
			<Cell>
				<Data ss:Type="String">
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
				<Data ss:Type="String">
					<xsl:choose><xsl:when test="$comp/FileUnderHost='true'">PEO</xsl:when><xsl:otherwise>ASO</xsl:otherwise></xsl:choose>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number($totalGross,'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FIT']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employee']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employer']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='MD_Employer']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employee']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employer']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SS_Employer']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FUTA']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='FUTA']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SIT']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SIT']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTD),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='ETT']/YTDWage),'####.##')"/>
				</Data>
			</Cell>
			<Cell ss:StyleID="s74">
				<Data ss:Type="Number">
					<xsl:value-of select="format-number(sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='ETT']/YTD),'####.##')"/>
				</Data>
			</Cell>
			
		</Row>
	</xsl:template>
	
</xsl:stylesheet>