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
   <NumberFormat ss:Format="mm:ss.0"/>
  </Style>
  <Style ss:ID="s63">
   <NumberFormat ss:Format="Short Date"/>
  </Style>
 </Styles>
			<xsl:apply-templates />
		</Workbook>
	</xsl:template>
	<xsl:template match="EmployeeTimesheet">
		<Worksheet>
<xsl:attribute name="ss:Name">
    <xsl:value-of select="Name" />
  </xsl:attribute>
			<Table x:FullColumns="1" x:FullRows="1">
				<Column ss:Index="1" ss:StyleID="s63" ss:Width="93"/>
        <Column ss:Index="2" ss:StyleID="Default" ss:Width="100"/>
				<Column ss:Index="5" ss:StyleID="Default" ss:Width="200"/>
        <Column ss:Index="9" ss:StyleID="s63" ss:Width="93"/>
				<Column ss:Index="11" ss:StyleID="s63" ss:Width="93"/>
			 
			 
			
   <Row>
    
		<Cell><Data ss:Type="String">Entry Date</Data></Cell>
    <Cell><Data ss:Type="String">Project</Data></Cell>
    <Cell><Data ss:Type="String">Hours</Data></Cell>
    <Cell><Data ss:Type="String">Overtime</Data></Cell>
    <Cell><Data ss:Type="String">Description</Data></Cell>
    <Cell><Data ss:Type="String">Approved?</Data></Cell>
		<Cell><Data ss:Type="String">Approved?</Data></Cell>
    <Cell><Data ss:Type="String">Approved By</Data></Cell>
    <Cell><Data ss:Type="String">Approved On</Data></Cell>
    <Cell><Data ss:Type="String">Paid ?</Data></Cell>
		<Cell><Data ss:Type="String">Paid On</Data></Cell>
    
   </Row>
   
				
				
				<xsl:apply-templates select="Timesheets/TimesheetEntry">
					
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
	<xsl:template match="TimesheetEntry">
		<Row>
			<Cell><Data ss:Type="String"><xsl:value-of select="EntryDateStr"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="ProjectName"/></Data></Cell>
			<Cell><Data ss:Type="Number"><xsl:value-of select="Hours"/></Data></Cell>
			<Cell><Data ss:Type="Number"><xsl:value-of select="Overtime"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="Description"/></Data></Cell>
      <Cell><Data ss:Type="String"><xsl:value-of select="IsApproved"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="ApprovedBy"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="ApprovedOnStr"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="IsPaid"/></Data></Cell>
			<Cell><Data ss:Type="String"><xsl:value-of select="PaidOn"/></Data></Cell>
			
		 </Row>
		
	</xsl:template>
	
</xsl:stylesheet>