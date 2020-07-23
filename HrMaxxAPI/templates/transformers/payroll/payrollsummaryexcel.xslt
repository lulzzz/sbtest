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
   <NumberFormat ss:Format="Short Date"/>
  </Style>
  <Style ss:ID="s65">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
    ss:Bold="1"/>
   <NumberFormat ss:Format="Short Date"/>
  </Style>
  <Style ss:ID="s66">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s67">
   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s68">
   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
 </Styles>
      <xsl:apply-templates select="Payroll" />
    </Workbook>
  </xsl:template>
  <xsl:template match="Payroll">
    <Worksheet>
      <xsl:attribute name="ss:Name">Payroll Summary</xsl:attribute>
      <Table x:FullColumns="1" x:FullRows="1">
        <Column ss:StyleID="s62" ss:Width="93"/>
   <Column ss:Width="99.75"/>
   <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="122.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="177"/>
   <Column ss:AutoFitWidth="0" ss:Width="77.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="76.5" ss:Span="1"/>
   <Column ss:Index="10" ss:AutoFitWidth="0" ss:Width="153"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="69.75" ss:Span="1"/>
   <Row>
    <Cell ss:StyleID="s65"><Data ss:Type="String">Employee</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">SSN</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Employee No</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Check #</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Pay Rate</Data></Cell>
    <Cell ss:MergeAcross="2" ss:StyleID="s67"><Data ss:Type="String">Wage Type</Data></Cell>
    <Cell ss:StyleID="s68"/>
    <Cell ss:MergeAcross="3" ss:StyleID="s67"><Data ss:Type="String">Pay Codes</Data></Cell>
   </Row>
   <Row>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s66"/>
    <Cell ss:StyleID="s66"/>
    <Cell ss:StyleID="s66"/>
    <Cell ss:StyleID="s66"/>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Type</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Amount</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">YTD</Data></Cell>
    <Cell ss:StyleID="s66"/>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Hours</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Overtime</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">Amount</Data></Cell>
   </Row>



        <xsl:choose>
          <xsl:when test="Company/CompanyCheckPrintOrder='CompanyEmployeeNo'">
            <xsl:apply-templates select="PayChecks/PayCheck[IsVoid='false']">
              <xsl:sort select="Employee/CompanyEmployeeNo" data-type="number"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="PayChecks/PayCheck[IsVoid='false']">
              <xsl:sort select="Employee/LastName" data-type="text"/>
              <xsl:sort select="Employee/FirstName" data-type="text"/>
              <xsl:sort select="Employee/MiddleInitial" data-type="text"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>

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
  <xsl:template match="PayCheck">
    <Row>
      <Cell>
        <Data ss:Type="String">
          <xsl:choose>
            <xsl:when test="Company/CompanyCheckPrintOrder='CompanyEmployeeNo'">
              <xsl:value-of select="concat(Employee/FirstName,' ',Employee/MiddleInitial, ' ', Employee/LastName)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(Employee/LastName,', ',Employee/FirstName, ' ', Employee/MiddleInitial)"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="String">
          <xsl:value-of select="concat('***-**-',substring(Employee/SSN,6,4))"/>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="String">
          <xsl:value-of select="Employee/CompanyEmployeeNo"/>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="String">
          <xsl:choose>
            <xsl:when test="PaymentMethod='Check'">
              <xsl:value-of select="CheckNumber"/>
            </xsl:when>
            <xsl:otherwise>EFT</xsl:otherwise>
          </xsl:choose>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(Employee/Rate,'#,##0.00')"/>
        </Data>
      </Cell>



    </Row>
    <Row>
      <Cell ss:Index="6">
        <Data ss:Type="String">Gross Wage</Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(GrossWage,'#,##0.00')"/>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(YTDGrossWage,'#,##0.00')"/>
        </Data>
      </Cell>
      <xsl:if test="PayCodes/PayrollPayCode[position()=1]">
        <xsl:call-template name="PayrollPayCode">
					<xsl:with-param name="pc" select="."/>
          <xsl:with-param name="position" select="1"/>
				</xsl:call-template>
        
      </xsl:if>
    </Row>
    <Row>
      <Cell ss:Index="6">
        <Data ss:Type="String">Salary</Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(Salary,'#,##0.00')"/>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(YTDSalary,'#,##0.00')"/>
        </Data>
      </Cell>
    <xsl:if test="PayCodes/PayrollPayCode[position()=2]">
        <xsl:call-template name="PayrollPayCode">
					<xsl:with-param name="pc" select="."/>
          <xsl:with-param name="position" select="2"/>
				</xsl:call-template>
        
      </xsl:if>
    </Row>
    <Row>
      <Cell ss:Index="6">
        <Data ss:Type="String">Net Wage</Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(NetWage,'#,##0.00')"/>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(YTDNetWage,'#,##0.00')"/>
        </Data>
      </Cell>
    <xsl:if test="PayCodes/PayrollPayCode[position()=3]">
        <xsl:call-template name="PayrollPayCode">
					<xsl:with-param name="pc" select="."/>
          <xsl:with-param name="position" select="3"/>
				</xsl:call-template>
        
      </xsl:if>
    </Row>
    <xsl:apply-templates select="Compensations/PayrollPayType"/>
  </xsl:template>
  <xsl:template match="PayrollPayType">
    <Row>
      <Cell ss:Index="6">
        <Data ss:Type="String">
          <xsl:value-of select="PayType/Name"/>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(Amount,'#,##0.00')"/>
        </Data>
      </Cell>
      <Cell>
        <Data ss:Type="Number">
          <xsl:value-of select="format-number(YTD,'#,##0.00')"/>
        </Data>
      </Cell>
    <xsl:if test="PayCodes/PayrollPayCode[position()=4]">
        <xsl:call-template name="PayrollPayCode">
					<xsl:with-param name="pc" select="."/>
          <xsl:with-param name="position" select="4"/>
				</xsl:call-template>
        
      </xsl:if>
    </Row>
  </xsl:template>
  <xsl:template name="PayrollPayCode">
    <xsl:param name="pc"/>
    <xsl:param name="position"/>
    <Cell>
          <Data ss:Type="String">
           
          </Data>
        </Cell>
<Cell >
          <Data ss:Type="String"><xsl:value-of select="$pc/PayCodes/PayrollPayCode[position()=$position]/PayCode/Description"/> ($ <xsl:value-of select="format-number($pc/PayCodes/PayrollPayCode[position()=$position]/PayCode/HourlyRate,'#,##0.00')"/>)</Data>
        </Cell>
        <Cell>
          <Data ss:Type="Number">
            <xsl:value-of select="format-number($pc/PayCodes/PayrollPayCode[position()=$position]/Hours,'#,##0.00')"/>
          </Data>
        </Cell>
        <Cell>
          <Data ss:Type="Number">
            <xsl:value-of select="format-number($pc/PayCodes/PayrollPayCode[position()=$position]/OvertimeHours,'#,##0.00')"/>
          </Data>
        </Cell>
      <Cell>
          <Data ss:Type="Number">
            <xsl:value-of select="format-number($pc/PayCodes/PayrollPayCode[position()=$position]/Amount,'#,##0.00')"/>
          </Data>
        </Cell>  
</xsl:template>

</xsl:stylesheet>