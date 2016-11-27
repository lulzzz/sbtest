<xsl:stylesheet version="1.0"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:msxsl="urn:schemas-microsoft-com:xslt"
 xmlns:user="urn:my-scripts"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" >

	<xsl:param name="batchFilerId"/>
	<xsl:param name="masterPinNumber"/>
	<xsl:param name="fileSeq"/>

	<xsl:param name="endQuarterMonth"/>
	<xsl:param name="selectedYear"/>
	<xsl:param name="today"/>
	<xsl:param name="settleDate"/>
	
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
			<xsl:apply-templates />
			
		</Workbook>
		
	</xsl:template>
	<xsl:template match="ExtractResponse">
		<Worksheet>
			<xsl:attribute name="ss:Name">
				<xsl:value-of select="concat('Federal 941 - ', $selectedYear)"/>
			</xsl:attribute>
			<Table x:FullColumns="1" x:FullRows="1">
				<Row>
					<Cell>
						<Data ss:Type="String">Year</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Period/Deposit Date</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Host</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Host Status</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Company</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Company No</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Company Status</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Batch Filer ID</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Master Inquiry Pin</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">File Date</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">File Sequence Number</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Payment Reference Number</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Action Code</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Taxpayer TIN</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Taxpayer PIN</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Taxpayer Type</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Tax Type Code</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Tax Period</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Settlement Date</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Payment Amount</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Subcategory Code1</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Subcategory Amount1</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Subcategory Code2</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Subcategory Amount2</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Subcategory Code3</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Subcategory Amount3</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Nothing1</Data>
					</Cell>

				</Row>
				<xsl:apply-templates select="Hosts/ExtractHost[count(Accumulation/PayChecks/PayCheck)>0]" >

				</xsl:apply-templates>
			</Table>
		</Worksheet>
	</xsl:template>

	<xsl:template match="ExtractHost">
		<xsl:variable name="totalSSWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=4]/TaxableWage - sum(Accumulation/Compensations[PayType/Id=3]/Amount)"/>
		<xsl:variable name="totalMDWages" select="Accumulation/Taxes/PayrollTax[Tax/Id=2]/TaxableWage"/>
		<xsl:variable name="totalFITTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=1]/Amount"/>
		<xsl:variable name="totalSSTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=4]/Amount + Accumulation/Taxes/PayrollTax[Tax/Id=5]/Amount"/>
		<xsl:variable name="totalMDTax" select="Accumulation/Taxes/PayrollTax[Tax/Id=2]/Amount + Accumulation/Taxes/PayrollTax[Tax/Id=3]/Amount"/>
		<xsl:variable name="line11" select="format-number(($totalFITTax + $totalSSTax + $totalMDTax),'000000000000.00')"/>
		<xsl:variable name="SSSum" select="format-number($totalSSTax,'000000000000.00')"/>
		<xsl:variable name="MDSum" select="format-number($totalMDTax,'000000000000.00')"/>
		<xsl:variable name="FITSum" select="format-number($totalFITTax,'000000000000.00')"/>

		<xsl:choose>
			<xsl:when test="$line11>0">
				<Row>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="$selectedYear"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="$endQuarterMonth"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="Host/FirmName"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="'A'"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="HostCompany/TaxFilingName"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="HostCompany/CompanyNo"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="'A'"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="format-number($batchFilerId,'000000000')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="format-number($masterPinNumber,'0000')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="$today"/>
						</Data>
					</Cell>

					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="format-number($fileSeq,'000')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(position(),'0000')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">P</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="translate(HostCompany/FederalEIN,'-','')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="HostCompany/FederalPin"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">B</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">94105</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="$selectedYear"/>
						</Data>
					</Cell>
					
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="$settleDate"/>
						</Data>
					</Cell>


					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(translate($line11,'.',''),'000000000000000')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">001</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(translate($SSSum,'.',''),'000000000000000')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">002</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(translate($MDSum,'.',''),'000000000000000')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">003</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="format-number(translate($FITSum,'.',''),'000000000000000')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">                    </Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">                </Data>
					</Cell>
				</Row>
			</xsl:when>
		</xsl:choose>
	</xsl:template>





</xsl:stylesheet>