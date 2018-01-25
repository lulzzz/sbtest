<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
	
  <xsl:param name="todaydate"/>
  
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:variable name="ein" select="concat(substring(/ReportResponse/Company/FederalEIN,1,2),'-',substring(/ReportResponse/Company/FederalEIN,3,7))"/>
	<xsl:variable name="compname" select="translate(/ReportResponse/Company/TaxFilingName,$smallcase,$uppercase)"/>
	<xsl:variable name="compaddress" select="translate(/ReportResponse/Company/BusinessAddress/AddressLine1,$smallcase, $uppercase)"/>
	<xsl:variable name="compcity" select="translate(/ReportResponse/Company/BusinessAddress/City,$smallcase, $uppercase)"/>
	<xsl:variable name="compzip" select="translate(/ReportResponse/Company/BusinessAddress/Zip,$smallcase, $uppercase)"/>
	
	
<xsl:output method="xml" indent="yes"/>

<xsl:template match="ReportResponse">
	<ReportTransformed>
		<Name>FilledFormC1095</Name>
		<Reports>
			<Report>
				<TemplatePath></TemplatePath>
				<Template></Template>
				<ReportType>Html</ReportType>
				<HtmlData>
					<html>
						<body>
							<div align="center">
								<h3>
									<xsl:value-of select="translate($compname,$smallcase,$uppercase)"/>
								</h3>
								<br/>
								<h4>
									<xsl:value-of select="translate($compaddress,$smallcase,$uppercase)"/>
								</h4>
								<h4>
									<xsl:value-of select="translate(concat($compcity,', CA',', ', $compzip),$smallcase,$uppercase)"/>
								</h4>
								<br/>
								<br/>
								<h5>
									C1095 Forms: <xsl:value-of select="count(EmployeeAccumulationList/Accumulation)"/>
								</h5>
							</div>
						</body>
					</html>

				</HtmlData>

			</Report>
			<xsl:apply-templates select="EmployeeAccumulationList/Accumulation">
				<xsl:sort select="FirstName"/>
			</xsl:apply-templates>
			
		</Reports>
	</ReportTransformed>	
</xsl:template>

<xsl:template match="Accumulation">
	<xsl:variable name="ssn" select="concat(substring(SSNVal,1,3),'-',substring(SSNVal,4,2),'-',substring(SSNVal,6,4))"/>
	<xsl:variable name="empname" select="translate(concat(FirstName, ' ', LastName),$smallcase,$uppercase)"/>
	<xsl:variable name="address" select="translate(Contact/Address/AddressLine1,$smallcase,$uppercase)"/>
	<xsl:variable name="city" select="translate(Contact/Address/City,$smallcase,$uppercase)"/>
	<xsl:variable name="state" select="translate('CA',$smallcase,$uppercase)"/>
	<xsl:variable name="zip" select="translate(Contact/Address/Zip,$smallcase,$uppercase)"/>
	<xsl:variable name="compstate" select="translate('CA',$smallcase, $uppercase)"/>
	<xsl:variable name="phone">
		<xsl:choose>
			<xsl:when test="/ReportResponse/Contact">
				<xsl:value-of select="concat('(',substring(/ReportResponse/Contact/Phone,1,3),') ',substring(/ReportResponse/Contact/Phone,4,3),'-',substring(/ReportResponse/Contact/Phone,7,4))"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<Report>
		<TemplatePath>GovtForms\C1095\</TemplatePath>
		<Template>C1095-<xsl:value-of select="$selectedYear"/>.pdf</Template>
		<Fields>
			
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'empname'"/><xsl:with-param name="val1" select="$empname"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'ssn'"/><xsl:with-param name="val1" select="$ssn"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="'address'"/><xsl:with-param name="val1" select="$address"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'city'"/>
				<xsl:with-param name="val1" select="$city"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'state'"/>
				<xsl:with-param name="val1" select="$state"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'zip'"/>
				<xsl:with-param name="val1" select="$zip"/>
			</xsl:call-template>

			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'compname'"/>
				<xsl:with-param name="val1" select="$compname"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'ein'"/>
				<xsl:with-param name="val1" select="$ein"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'compaddress'"/>
				<xsl:with-param name="val1" select="$compaddress"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'compcity'"/>
				<xsl:with-param name="val1" select="$compcity"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'compstate'"/>
				<xsl:with-param name="val1" select="$compstate"/>
			</xsl:call-template>
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'compzip'"/>
				<xsl:with-param name="val1" select="$compzip"/>
			</xsl:call-template>

			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="'phone'"/>
				<xsl:with-param name="val1" select="$phone"/>
			</xsl:call-template>
			
			<xsl:choose>
				<xsl:when test="C1095Line14All=''">
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_1'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=1]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_2'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=2]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_3'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=3]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_4'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=4]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_5'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=5]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_6'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=6]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_7'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=7]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_8'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=8]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_9'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=9]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_10'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=10]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_11'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=11]/Code14"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_12'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=12]/Code14"/>
					</xsl:call-template>
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14'"/>
						<xsl:with-param name="val1" select="C1095Line14All"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_1'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_2'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_3'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_4'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_5'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_6'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_7'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_8'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_9'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_10'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_11'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'14_12'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="C1095Line15All=''">
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-1'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=1]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-2'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=2]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-3'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=3]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-4'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=4]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-5'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=5]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-6'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=6]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-7'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=7]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-8'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=8]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-9'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=9]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-10'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=10]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-11'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=11]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-12'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=12]/Value,'###0.00')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15'"/>
						<xsl:with-param name="val1" select="format-number(C1095Months/C1095Month[Month=1]/Value,'###0.00')"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-1'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-2'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-3'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-4'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-5'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-6'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-7'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-8'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-9'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-10'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-11'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'15-12'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="C1095Line16All=''">
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-1'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=1]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-2'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=2]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-3'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=3]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-4'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=4]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-5'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=5]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-6'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=6]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-7'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=7]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-8'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=8]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-9'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=9]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-10'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=10]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-11'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=11]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-12'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=12]/Code16"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16'"/>
						<xsl:with-param name="val1" select="C1095Months/C1095Month[Month=1]/Code16"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-1'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-2'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-3'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-4'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-5'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-6'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-7'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-8'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-9'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-10'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-11'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					<xsl:call-template name="FieldTemplate">
						<xsl:with-param name="name1" select="'16-12'"/>
						<xsl:with-param name="val1" select="''"/>
					</xsl:call-template>
					
				</xsl:otherwise>
			</xsl:choose>
		</Fields>
	
	</Report>
</xsl:template>	




</xsl:stylesheet>

  