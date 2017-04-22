<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:foo="http://whatever"
>
	<xsl:param name="identifier"/>
  <xsl:param name="endQuarterMonth"/>
  <xsl:param name="selectedYear"/>
	<xsl:param name="quarter"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="/">
<xsl:apply-templates select="ExtractHost" >
</xsl:apply-templates>
    
  </xsl:template>
  <xsl:template match="ExtractHost">
		
		<xsl:variable name="SUIRate">
			<xsl:value-of select="format-number(HostCompany/CompanyTaxRates/CompanyTaxRate[TaxId=10 and TaxYear=$selectedYear]/Rate div 100, '#0.00000')"/>
		</xsl:variable>
		<xsl:variable name="ETTRate">
			<xsl:value-of select="format-number(HostCompany/CompanyTaxRates/CompanyTaxRate[TaxId=9 and TaxYear=$selectedYear]/Rate div 100, '#0.00000')"/>
		</xsl:variable>
		<ReturnDataState xsi:schemaLocation="http://www.irs.gov/efileReturnDataState.xsd" xmlns="http://www.irs.gov/efile" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<ContentLocation>
				<xsl:value-of select="concat($identifier,'-',HostCompany/Id)"/>
			</ContentLocation>
			<ReturnHeaderState>
				<ReturnQuarter>
					<xsl:value-of select="$quarter"/>
				</ReturnQuarter>
				<Taxyear>
					<xsl:value-of select="$selectedYear"/>
				</Taxyear>
				<PreparerFirm>
					<BusinessName>
						<BusinessNameLine1>GIIG</BusinessNameLine1>
					</BusinessName>
					<Address>
						<USAddress>
							<AddressLine1>500 N. STATE COLLEGE BLVD #1100</AddressLine1>
							<City>ORANGE</City>
							<State>CA</State>
							<ZipCode>92868</ZipCode>
						</USAddress>
					</Address>
				</PreparerFirm>
				<ReturnType>StateAnnual</ReturnType>
				<StateEIN>
					<TypeStateEIN>WithholdingAccountNo</TypeStateEIN>
					<StateEINValue>
						<xsl:value-of select="translate(States/CompanyTaxState[State/StateId=1]/StateEIN,'-','')"/>
					</StateEINValue>
				</StateEIN>
				<StateCode>CA</StateCode>
				</ReturnHeaderState>
				<StateGeneralInformation>
					<BusinessAddress>
						<BusinessName>
							<BusinessNameLine1>
								<xsl:value-of select="HostCompany/TaxFilingName"/>
							</BusinessNameLine1>
						</BusinessName>
						<Address>
							<USAddress>
								<AddressLine1><xsl:value-of select="HostCompany/BusinessAddress/AddressLine1"/></AddressLine1>
								<City>
									<xsl:value-of select="HostCompany/BusinessAddress/City"/>
								</City>
								<State>
									<xsl:value-of select="'CA'"/>
								</State>
								<ZipCode>
									<xsl:value-of select="HostCompany/BusinessAddress/Zip"/>
								</ZipCode>
							</USAddress>
						</Address>
					</BusinessAddress>
				</StateGeneralInformation>
				<StateAnnual>
				<TotalWagesYear>
					<xsl:value-of select="PayCheckAccumulation/PayCheckWages/GrossWage"/>
				</TotalWagesYear>
				<TotalIncomeTaxWithheld>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SIT']/YTD"/>
				</TotalIncomeTaxWithheld>
				<UITaxableWagesYear>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTDWage"/>
				</UITaxableWagesYear>
				<UITaxRate>
					<xsl:value-of select="$SUIRate"/>
				</UITaxRate>
				<UITaxesYear>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SUI']/YTD"/>
				</UITaxesYear>
				<EmploymentTrainingTaxRate>
					<xsl:value-of select="$ETTRate"/>
				</EmploymentTrainingTaxRate>
				<EmploymentTrainingTaxesYear>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='ETT']/YTD"/>
				</EmploymentTrainingTaxesYear>
				<DITaxableWagesYear>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/YTDWage"/>
				</DITaxableWagesYear>
				<DITaxRate>
					<xsl:value-of select="format-number(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/Tax/Rate div 100, '#0.00000')"/>
				</DITaxRate>
				<DITaxesYear>
					<xsl:value-of select="PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI']/YTD"/>
				</DITaxesYear>
					<TotalContributionsYear>
						<xsl:value-of select="sum(PayCheckAccumulation/Taxes/PayCheckTax[Tax/Code='SDI' or Tax/Code='SIT' or Tax/Code='SUI' or Tax/Code='ETT']/YTD)"/>
					</TotalContributionsYear>
				<TotalCreditsYear>0.00</TotalCreditsYear>
				<WHBalanceDue>0.00</WHBalanceDue>
			</StateAnnual>
		</ReturnDataState>

  </xsl:template>
  
</xsl:stylesheet>
