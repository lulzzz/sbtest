<xsl:stylesheet version="1.0"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:msxsl="urn:schemas-microsoft-com:xslt"
 xmlns:user="urn:my-scripts"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" >

	<xsl:param name="selectedYear"/>
	<xsl:param name="reportConst"/>
	<xsl:param name="enddate"/>
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
				<xsl:value-of select="concat('CA PIT and DI - ', $selectedYear)"/>
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
						<Data ss:Type="String">State Abbreviation</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Authority Code</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Account Number</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Security Code</Data>
					</Cell>

					<Cell>
						<Data ss:Type="String">Tax Type Code</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Nothing1</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Employee CA SDI total for period specified in the dropdown</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Nothing2</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Employee CA Income Tax total for period specified in the dropdown</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Nothing3</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Total Dollar Amount</Data>
					</Cell>

					<Cell>
						<Data ss:Type="String">Verification Code</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Payroll Date</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Nothing4</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">Debit Date</Data>
					</Cell>

				</Row>
				<xsl:apply-templates select="Hosts/ExtractHost[count(PayChecks/PayCheck)>0]" >

				</xsl:apply-templates>
			</Table>
		</Worksheet>
	</xsl:template>

	<xsl:template match="ExtractHost">
		<xsl:variable name="SDISum" select="Accumulation/Taxes/PayrollTax[Tax/Code='SDI']/Amount"/>
		<xsl:variable name="SITSum" select="Accumulation/Taxes/PayrollTax[Tax/Code='SIT']/Amount"/>
		<xsl:variable name="totalTax" select="$SDISum + $SITSum"/>
		<xsl:variable name="SDISumString" select="format-number($SDISum,'00000000000.00')"/>
		<xsl:variable name="SITSumString" select="format-number($SITSum,'00000000000.00')"/>
		<xsl:variable name="totalTaxString" select="format-number($totalTax,'00000000000.00')"/>
		<xsl:variable name="totalTaxStringL" select="format-number($totalTax,'###########.00')"/>
		<xsl:choose>
			<xsl:when test="$totalTax>0">
				<Row>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="$selectedYear"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							
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
						<Data ss:Type="String">CA</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">0055</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="translate(States/CompanyTaxState[State/StateId=1]/StateEIN,'-','')"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="States/CompanyTaxState[State/StateId=1]/StatePIN"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="$reportConst"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String"></Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="$SDISum"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String"></Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="$SITSum"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String"></Data>
					</Cell>
					<Cell>
						<Data ss:Type="Number">
							<xsl:value-of select="$totalTax"/>
						</Data>
					</Cell>
					<xsl:call-template name="for-each-character">
						<xsl:with-param name="data" select="$totalTaxString"/>
						<xsl:with-param name="count" select="0"/>
						<xsl:with-param name="finalAdd" select="string-length($totalTaxStringL)"/>
					</xsl:call-template>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="$enddate"/>
						</Data>
					</Cell>
					<Cell>
						<Data ss:Type="String"></Data>
					</Cell>
					<Cell>
						<Data ss:Type="String">
							<xsl:value-of select="$settleDate"/>
						</Data>
					</Cell>

				</Row>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="for-each-character">
		<xsl:param name="data"/>
		<xsl:param name="count"/>
		<xsl:param name="finalAdd"/>
		<xsl:variable name="charc" select="substring($data,1,1)"/>

		<xsl:choose>

			<xsl:when test="string-length($data) > 1">
				<xsl:choose>
					<xsl:when test="$charc='.'">
						<xsl:call-template name="for-each-character">
							<xsl:with-param name="data" select="substring($data,2)"/>
							<xsl:with-param name="count" select="$count - 1"/>
							<xsl:with-param name="finalAdd" select="$finalAdd"/>
						</xsl:call-template>

					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="for-each-character">
							<xsl:with-param name="data" select="substring($data,2)"/>
							<xsl:with-param name="count" select="$count + $charc"/>
							<xsl:with-param name="finalAdd" select="$finalAdd"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			<xsl:otherwise>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($finalAdd+$count+$charc,'00')"/>
					</Data>
				</Cell>

			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>




</xsl:stylesheet>