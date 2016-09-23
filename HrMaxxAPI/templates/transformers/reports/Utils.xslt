<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:math="http://exslt.org/math"
>
<xsl:template name="FieldTemplate">                 
		<xsl:param name="name1"/> 
		<xsl:param name="val1"/>
		<Field>
			<Name><xsl:value-of select="$name1"/></Name>
			<Type>Text</Type>
			<Value><xsl:value-of select="$val1"/>
		</Value>
		</Field>    
	</xsl:template>
	<xsl:template name="Amount">
		<xsl:param name="name1"/>
		<xsl:param name="val1"/>
		<Field>
			<Name>
				<xsl:value-of select="$name1"/>
			</Name>
			<Type>Text</Type>
			<Value>
				<xsl:choose>
					<xsl:when test="$val1">
						<xsl:value-of select="concat('$',format-number($val1,'#,##0.00'))"/>
					</xsl:when>
					<xsl:otherwise>$0.00</xsl:otherwise>
				</xsl:choose>
			</Value>
		</Field>
	</xsl:template>
	<xsl:template name="CheckTemplate">                 
		<xsl:param name="name1"/> 
		<xsl:param name="val1"/>
		<Field>
			<Name><xsl:value-of select="$name1"/></Name>
			<Type>Check</Type>
			<Value><xsl:value-of select="$val1"/></Value>
		</Field>    
	</xsl:template>
  <xsl:template name="DecimalFieldTemplate">
	<xsl:param name="field1"/>
	<xsl:param name="field2"/>
	<xsl:param name="val"/>
	<xsl:variable name="thisval">
		<xsl:choose>
		<xsl:when test="number($val)=$val"><xsl:value-of select="$val"></xsl:value-of></xsl:when>
		<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$thisval>=0">
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$field1"/><xsl:with-param name="val1" select="floor($thisval)"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$field2"/><xsl:with-param name="val1" select="format-number(($thisval - floor($thisval))*100,'00')"/></xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="val2" select="$thisval*-1"/>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$field1"/><xsl:with-param name="val1" select="concat('-',floor($val2))"/></xsl:call-template>
			<xsl:call-template name="FieldTemplate"><xsl:with-param name="name1" select="$field2"/><xsl:with-param name="val1" select="format-number(($val2 - floor($val2))*100,'00')"/></xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	
  </xsl:template>
  
  <xsl:template name="dailyTemplate">
	<xsl:param name="month"/>
	<xsl:param name="day"/>
	<xsl:param name="daysinmonth"/>
	<xsl:variable name="fieldConst" select="((64*($month - 1))+9)+$day*2"/>
	<xsl:call-template name="dailyTemplate2">
		<xsl:with-param name="month" select="$month"/>
		<xsl:with-param name="day" select="$day"/>
		<xsl:with-param name="fieldPrefix" select="'f1-'"/>		
		<xsl:with-param name="fieldConst" select="$fieldConst"/>		
	</xsl:call-template>
	<xsl:choose>
		<xsl:when test="$day > 1">
			<xsl:call-template name="dailyTemplate">
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="$day - 1"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="$day=$daysinmonth">
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="concat('f1-',$fieldConst + 2)"/>
				<xsl:with-param name="field2" select="concat('f1-',$fieldConst + 3)"/>
				<xsl:with-param name="val" select="sum(/ReportResponse/CompanyAccumulation/DailyAccumulations/DailyAccumulation[Month=$month]/Value)"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
  </xsl:template>
  <xsl:template name="dailyTemplate2">
	<xsl:param name="month"/>
	<xsl:param name="day"/>
	<xsl:param name="fieldPrefix"/>
	<xsl:param name="fieldConst"/>
	<xsl:choose>
		<xsl:when test="/ReportResponse/CompanyAccumulation/DailyAccumulations/DailyAccumulation[Month=$month and Day=$day]">
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="concat($fieldPrefix,$fieldConst)"/>
				<xsl:with-param name="field2" select="concat($fieldPrefix,$fieldConst+1)"/>
				<xsl:with-param name="val" select="/ReportResponse/CompanyAccumulation/DailyAccumulations/DailyAccumulation[Month=$month and Day=$day]/Value"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="DecimalFieldTemplate">
				<xsl:with-param name="field1" select="concat($fieldPrefix,$fieldConst)"/>
				<xsl:with-param name="field2" select="concat($fieldPrefix,$fieldConst+1)"/>
				<xsl:with-param name="val" select="0"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>	
  </xsl:template>
  <xsl:template name="dailyTemplate944">
	<xsl:param name="starter"/>
	<xsl:param name="month"/>
	<xsl:param name="day"/>
	<xsl:param name="daysinmonth"/>
	<xsl:variable name="fieldConst" select="$starter+($day - 1)*2"/>
	<xsl:variable name="fieldPrefix">
		<xsl:choose>
			<xsl:when test="$month &lt; 7">f1-</xsl:when>
			<xsl:otherwise>f2-</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	
	<xsl:call-template name="dailyTemplate2">
		<xsl:with-param name="month" select="$month"/>
		<xsl:with-param name="day" select="$day"/>
		<xsl:with-param name="fieldPrefix" select="$fieldPrefix"/>
		<xsl:with-param name="fieldConst" select="$fieldConst"/>
	</xsl:call-template>
	<xsl:choose>
		<xsl:when test="$day > 1">
			<xsl:call-template name="dailyTemplate944">
				<xsl:with-param name="starter" select="$starter"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="$day - 1"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="$day=$daysinmonth">
			<xsl:call-template name="FieldTemplate">
				<xsl:with-param name="name1" select="concat($fieldPrefix,$fieldConst + 2)"/>
				<xsl:with-param name="val1" select="format-number(sum(/ReportResponse/CompanyAccumulation/DailyAccumulations/DailyAccumulation[Month=$month]/Value),'#####0.00')"/>
			</xsl:call-template>				
		</xsl:when>
	</xsl:choose>
  </xsl:template>
 </xsl:stylesheet>