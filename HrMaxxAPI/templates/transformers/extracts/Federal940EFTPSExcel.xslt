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
				<xsl:value-of select="concat('Federal 940 - ', $selectedYear)"/>
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
					
				</Row>
				<xsl:apply-templates select="Hosts/ExtractHost[count(Accumulation/PayChecks/PayCheck)>0]" >

				</xsl:apply-templates>
			</Table>
		</Worksheet>
	</xsl:template>

	<xsl:template match="ExtractHost">
		<xsl:variable name="totalFUTATax" select="Accumulation/Taxes/PayrollTax[Tax/Code='FUTA']/Amount"/>
		<xsl:variable name="FUTASum" select="format-number($totalFUTATax,'000000000000.00')"/>

		<xsl:choose>
			<xsl:when test="$FUTASum>0">
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
							<xsl:value-of select="format-number(translate($FUTASum,'.',''),'000000000000000')"/>
						</Data>
					</Cell>
					
				</Row>
			</xsl:when>
		</xsl:choose>
	</xsl:template>





</xsl:stylesheet>