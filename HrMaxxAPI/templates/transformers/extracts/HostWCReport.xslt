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
		<Worksheet ss:Name="Totals">
			<Table x:FullColumns="1"
			 x:FullRows="1" ss:DefaultRowHeight="15">
				<Column ss:AutoFitWidth="0" ss:Width="84"/>
				<Column ss:AutoFitWidth="0" ss:Width="97.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="345"/>
				<Column ss:AutoFitWidth="0" ss:Width="87.75"/>
				<Column ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="83.25"/>
				<Column ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="81.75"/>
				<Row ss:AutoFitHeight="0">
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Idlns</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Client_Number</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Client_Name</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">WC_Class</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Gross</Data>
					</Cell>
					<Cell ss:StyleID="s63">
						<Data ss:Type="String">Overtime</Data>
					</Cell>
				</Row>
				<xsl:apply-templates select="Hosts/ExtractHost/Companies/ExtractCompany" mode="Totals"/>
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
		<Worksheet ss:Name="WC Report">
			<Table x:FullColumns="1"
			 x:FullRows="1" ss:DefaultRowHeight="15">
				<Column ss:AutoFitWidth="0" ss:Width="60.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="71.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="78.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="76.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="81.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="168"/>
				<Column ss:AutoFitWidth="0" ss:Width="81"/>
				<Column ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:AutoFitWidth="0" ss:Width="89.25"/>
				<Row>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Idlns</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Client</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">SSN</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Class_Code</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">State_Code</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Name</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Cmd_Emp</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Subject_Pay</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Overtime</Data>
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
		<Worksheet ss:Name="Without WC">
			<Table x:FullColumns="1"
			 x:FullRows="1" ss:DefaultRowHeight="15">
				<Column ss:AutoFitWidth="0" ss:Width="60.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="71.25"/>
				<Column ss:AutoFitWidth="0" ss:Width="78.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="76.5"/>
				<Column ss:AutoFitWidth="0" ss:Width="81.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="168"/>
				<Column ss:AutoFitWidth="0" ss:Width="81"/>
				<Column ss:AutoFitWidth="0" ss:Width="87"/>
				<Column ss:AutoFitWidth="0" ss:Width="89.25"/>
				<Row>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Idlns</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Client</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">SSN</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Class_Code</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">State_Code</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Name</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Cmd_Emp</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Subject_Pay</Data>
					</Cell>
					<Cell ss:StyleID="s62">
						<Data ss:Type="String">Overtime</Data>
					</Cell>
				</Row>
				<xsl:apply-templates select="Hosts/ExtractHost/Companies/ExtractCompany" mode="NotWC"/>
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
		<xsl:variable name ="acc" select="Accumulation"/>
		<xsl:for-each select="Accumulation/WorkerCompensations/PayrollWorkerCompensation">
			<xsl:variable name ="wcid" select="WorkerCompensation/Id"/>
			<xsl:variable name="overtime" select="sum($host/PayChecks/PayCheck[CompanyId=$comp/Id and WorkerCompensation/WorkerCompensation/Id=$wcid]/PayCodes/PayrollPayCode/OvertimeAmount)"/>
			<Row>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="$comp/InsuranceGroup/GroupNo"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="$comp/InsuranceClientNo" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="translate($comp/TaxFilingName,$smallcase,$uppercase)" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="WorkerCompensation/Code"/>
					</Data>
				</Cell>
				<Cell ss:StyleID="s64">
					<Data ss:Type="Number">
						<xsl:value-of select="format-number(Wage - $overtime,'######0.00')"/>
					</Data>
				</Cell>
				<Cell ss:StyleID="s64">
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($overtime,'######0.00')"/>
					</Data>
				</Cell>
			</Row>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ExtractCompany" mode="WC">
		<xsl:variable name="host" select="../.."/>
		<xsl:variable name ="comp" select="Company"/>
		<xsl:for-each select="EmployeeAccumulations/EmployeeAccumulation[Accumulation/WorkerCompensations/PayrollWorkerCompensation/Amount>0]">
			<xsl:variable name="emp" select="Employee"/>
			<xsl:variable name="acc" select="Accumulation"/>
			<xsl:for-each select="Accumulation/WorkerCompensations/PayrollWorkerCompensation[Amount>0]">
				<xsl:variable name="wcid" select="WorkerCompensation/Id"/>
				<xsl:variable name="overtime" select="sum($host/PayChecks/PayCheck[Employee/Id=$emp/Id and WorkerCompensation/WorkerCompensation/Id=$wcid]/PayCodes/PayrollPayCode/OvertimeAmount)"/>
			<Row>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="$comp/InsuranceGroup/GroupNo"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="$comp/InsuranceClientNo" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="concat(substring($emp/SSN, 1,3),'-',substring($emp/SSN, 4,2),'-',substring($emp/SSN,6,4))" />
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="WorkerCompensation/Code"/>
					</Data>
				</Cell>
				<Cell >
					<Data ss:Type="String">
						<xsl:value-of select="'CA'"/>
					</Data>
				</Cell>
				<Cell >
					<Data ss:Type="String">
						<xsl:value-of select="concat($emp/LastName, ' ,', $emp/FirstName,' ', $emp/MiddleInitial)"/>
					</Data>
				</Cell>
				<Cell >
					<Data ss:Type="String">
						<xsl:value-of select="$emp/EmployeeNo"/>
					</Data>
				</Cell>
				<Cell ss:StyleID="s64">
					<Data ss:Type="Number">
						<xsl:value-of select="format-number(Wage - $overtime,'######0.00')"/>
					</Data>
				</Cell>
				<Cell ss:StyleID="s64">
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($overtime,'######0.00')"/>
					</Data>
				</Cell>
			</Row>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ExtractCompany" mode="NotWC">
		<xsl:variable name="host" select="../.."/>
		<xsl:variable name ="comp" select="Company"/>
		<xsl:for-each select="EmployeeAccumulations/EmployeeAccumulation">
			<xsl:variable name="emp" select="Employee"/>
			<xsl:variable name="acc" select="Accumulation"/>
			<xsl:for-each select="Accumulation/WorkerCompensations/PayrollWorkerCompensation[Amount=0]">
				<xsl:variable name="wcid" select="WorkerCompensation/Id"/>
				<xsl:variable name="overtime" select="sum($host/PayChecks/PayCheck[Employee/Id=$emp/Id and WorkerCompensation/WorkerCompensation/Id=$wcid]/PayCodes/PayrollPayCode/OvertimeAmount)"/>
				<Row>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="$comp/InsuranceGroup/GroupNo"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="$comp/InsuranceClientNo" />
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="concat(substring($emp/SSN, 1,3),'-',substring($emp/SSN, 4,2),'-',substring($emp/SSN,6,4))" />
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="WorkerCompensation/Code"/>
						</Data>
					</Cell>
					<Cell >
						<Data ss:Type="String">
							<xsl:value-of select="'CA'"/>
						</Data>
					</Cell>
					<Cell >
						<Data ss:Type="String">
							<xsl:value-of select="concat($emp/LastName, ' ,', $emp/FirstName,' ', $emp/MiddleInitial)"/>
						</Data>
					</Cell>
					<Cell >
						<Data ss:Type="String">
							<xsl:value-of select="$emp/EmployeeNo"/>
						</Data>
					</Cell>
					<Cell ss:StyleID="s64">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(Wage - $overtime,'######0.00')"/>
						</Data>
					</Cell>
					<Cell ss:StyleID="s64">
						<Data ss:Type="Number">
							<xsl:value-of select="format-number($overtime,'######0.00')"/>
						</Data>
					</Cell>
				</Row>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>