<xsl:stylesheet version="1.0" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="urn:my-scripts" xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:fn="http://exslt.org/math">
	<xsl:param name="selectedYear" />
	<xsl:param name="todaydate" />
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
   <NumberFormat ss:Format="mm:ss.0"/>
  </Style>
  <Style ss:ID="s63">
   <NumberFormat ss:Format="Short Date"/>
  </Style>
 </Styles>
			<xsl:apply-templates />
		</Workbook>
	</xsl:template>
	<xsl:template match="EmployeeSickLeave">
		<Worksheet>
<xsl:attribute name="ss:Name">
    <xsl:value-of select="Name" />
  </xsl:attribute>
			<Table x:FullColumns="1" x:FullRows="1">
				<Column ss:Index="2" ss:StyleID="s63" ss:Width="93"/>
				<Column ss:Index="3" ss:StyleID="s63" ss:Width="93"/>
				<Column ss:Index="5" ss:StyleID="s63" ss:Width="93"/>
			 <Column ss:Index="6"  ss:Width="93"/>
				<Column ss:Index="7"  ss:Width="93"/>
				<Column ss:Index="8" ss:StyleID="s63" ss:Width="93"/>
				<Column ss:Index="9" ss:StyleID="s63" ss:Width="93"/>
			 
			
   <Row>
    
		<Cell><Data ss:Type="String">CompanyEmployeeNo</Data></Cell>
    <Cell><Data ss:Type="String">HireDate</Data></Cell>
    <Cell><Data ss:Type="String">SickLeaveHireDate</Data></Cell>
    <Cell><Data ss:Type="String">CarryOver</Data></Cell>
    <Cell><Data ss:Type="String">PayDay</Data></Cell>
    <Cell><Data ss:Type="String">PayCheckId</Data></Cell>
    <Cell><Data ss:Type="String">CheckNumber</Data></Cell>
    <Cell><Data ss:Type="String">Leave Type</Data></Cell>
     <Cell><Data ss:Type="String">FiscalStart</Data></Cell>
    <Cell><Data ss:Type="String">FiscalEnd</Data></Cell>
    <Cell><Data ss:Type="String">AccumulatedValue</Data></Cell>
    <Cell><Data ss:Type="String">Used</Data></Cell>
    <Cell><Data ss:Type="String">CarryOver</Data></Cell>
    <Cell><Data ss:Type="String">YTD</Data></Cell>
    <Cell><Data ss:Type="String">YTDUsed</Data></Cell>
    <Cell><Data ss:Type="String">Available</Data></Cell>
   </Row>
   
				
				
				<xsl:apply-templates select="Accumulations/SickLeaveAccumulation">
					<xsl:sort select="Id" data-type="number" order="ascending"/>
				</xsl:apply-templates>
				
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<Print>
					<ValidPrinterInfo />
					<HorizontalResolution>200</HorizontalResolution>
					<VerticalResolution>200</VerticalResolution>
				</Print>
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>2</ActiveRow>
						<RangeSelection>R3</RangeSelection>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
		
	</xsl:template>
	<xsl:template match="SickLeaveAccumulation">
		<Row>
			<Cell><Data ss:Type="String"><xsl:value-of select="../../CompanyEmployeeNo"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="../../HireDate"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="../../SickLeaveHireDate"/></Data></Cell>
			<Cell><Data ss:Type="Number"><xsl:value-of select="../../CarryOver"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="PayDay"/></Data></Cell>
			<Cell><Data ss:Type="Number"><xsl:value-of select="Id"/></Data></Cell>
			<Cell><Data ss:Type="Number"><xsl:value-of select="CheckNumber"/></Data></Cell>
      <Cell><Data ss:Type="String"><xsl:value-of select="PayTypeName"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="FiscalStart"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="FiscalEnd"/></Data></Cell>
			<Cell><Data ss:Type="Number"><xsl:value-of select="AccumulatedValue"/></Data></Cell>
			<Cell><Data ss:Type="Number"><xsl:value-of select="Used"/></Data></Cell>
			<Cell><Data ss:Type="Number"><xsl:value-of select="CarryOver"/></Data></Cell>
			<Cell ><Data ss:Type="Number"><xsl:value-of select="YTDFiscal"/></Data></Cell>
			<Cell ><Data ss:Type="Number"><xsl:value-of select="YTDUsed"/></Data></Cell>
			<Cell ><Data ss:Type="Number"><xsl:value-of select="Available"/></Data></Cell>
		 </Row>
		
	</xsl:template>
	
</xsl:stylesheet>