<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    
>
<xsl:import href="../Utils.xslt" />
<xsl:param name="selectedYear"/>
	
  
	<xsl:param name="county"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:variable name="emps" select="count(/ReportResponse/EmployeeAccumulationList/Accumulation)"/>
	
	
	
<xsl:output method="text" indent="no"/>
	
	<xsl:template match="ReportResponse">
		<xsl:apply-templates select="EmployeeAccumulationList/Accumulation"/>
		
	</xsl:template>

<xsl:template match="Accumulation">
<xsl:value-of select="$emps"/>, <xsl:value-of select="translate($county,$smallcase,$uppercase)"/>, 0, <xsl:value-of select="SSNVal"/>, <xsl:value-of select="concat(LastName, ' ', substring(FirstName,1,1))"/>, <xsl:value-of select="ApplicableWages"/>, 0
<xsl:text>$$n</xsl:text>
</xsl:template>	
</xsl:stylesheet>

  