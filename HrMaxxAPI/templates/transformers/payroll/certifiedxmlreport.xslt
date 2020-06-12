<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:math="http://exslt.org/math" exclude-result-prefixes="msxsl" xmlns:CPR="http://www.dir.ca.gov/dlse/CPR-Prod-Test/CPR.xsd"
    
>
  <xsl:import href="../reports/Utils.xslt" />

  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:param name="timesheets"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="employeeCount" select="count(/CertifiedPayroll/Payroll/PayChecks/PayCheck)"/>
  <xsl:variable name="pages" select="ceiling($employeeCount div 4)"/>
  <xsl:variable name="project" select="/CertifiedPayroll/Payroll/Project"/>
  <xsl:template match="CertifiedPayroll">
    <CPR:eCPR xmlns:CPR="http://www.dir.ca.gov/dlse/CPR-Prod-Test/CPR.xsd">
      <xsl:apply-templates select="Payroll/Company"/>
      <xsl:apply-templates select="Payroll/Project"/>
      <CPR:payrollInfo>
        <CPR:statementOfNP>false</CPR:statementOfNP>
        <CPR:payrollNum>
          <xsl:value-of select="Payroll/PayrollNo"/>
        </CPR:payrollNum>
        <CPR:amendmentNum/>
        <CPR:forWeekEnding>
          <xsl:value-of select="msxsl:format-date(Payroll/EndDate, 'yyyy-MM-dd')"/>
        </CPR:forWeekEnding>
        <CPR:employees>
          <xsl:apply-templates select="Payroll/PayChecks/PayCheck"></xsl:apply-templates>

        </CPR:employees>
      </CPR:payrollInfo>
    </CPR:eCPR>

  </xsl:template>
  <xsl:template match="TimesheetEntry">
    <CPR:day>
      <xsl:attribute name="id">
        <xsl:value-of select="Day"/>
      </xsl:attribute>
      <CPR:date>
        <xsl:value-of select="msxsl:format-date(EntryDate, 'yyyy-MM-dd')"/>
      </CPR:date>
      <CPR:straightTime>
        <xsl:value-of select="Hours"/>
      </CPR:straightTime>
      <CPR:overtime>
        <xsl:value-of select="Overtime"/>
      </CPR:overtime>
      <CPR:doubletime>0.0</CPR:doubletime>
    </CPR:day>

  </xsl:template>
  <xsl:template match="PayCheck">
    <xsl:variable name="emp" select ="Employee/Id"/>
    <xsl:variable name ="bpc" select="PayCodes/PayrollPayCode[PayCode/Id=0]"/>
    <CPR:employee>
      <CPR:name>
        <xsl:attribute name="id">
          <xsl:value-of select="concat(Employee/CompanyEmployeeNo,'::', Employee/FullName)"/>
        </xsl:attribute>
        <xsl:value-of select="Employee/FullName"/>
      </CPR:name>
      <CPR:address>
        <CPR:street>
          <xsl:value-of select="Employee/Contact/Address/AddressLine1"/>
        </CPR:street>
        <CPR:city>
          <xsl:value-of select="Employee/Contact/Address/City"/>
        </CPR:city>
        <CPR:state>
          <xsl:value-of select="Employee/Contact/Address/StateCode"/>
        </CPR:state>
        <CPR:zip>
          <xsl:value-of select="Employee/Contact/Address/Zip"/>
        </CPR:zip>
      </CPR:address>
      <CPR:ssn>
        <xsl:value-of select="Employee/SSN"/>
      </CPR:ssn>
      <CPR:numWithholdingExemp>
        <xsl:value-of select="Employee/FederalExemptions"/>
      </CPR:numWithholdingExemp>
      <CPR:workClass>
        <xsl:value-of select="Employee/WorkClassification"/>
      </CPR:workClass>
      <CPR:payroll>


        <CPR:hrsWorkedEachDay>
          <xsl:apply-templates select="//CertifiedPayroll/Timesheets/TimesheetEntry[EmployeeId=$emp]">
            <xsl:sort select="Day" data-type="number"/>
          </xsl:apply-templates>

        </CPR:hrsWorkedEachDay>
        <CPR:totHrs>
          <CPR:totHrsStraightTime>
            <xsl:value-of select="$bpc/Hours"/>
          </CPR:totHrsStraightTime>
          <CPR:totHrsOvertime>
            <xsl:value-of select="$bpc/OvertimeHours"/>
          </CPR:totHrsOvertime>
          <CPR:totHrsDoubletime>0.0</CPR:totHrsDoubletime>
        </CPR:totHrs>
        <CPR:hrlyPayRate>
          <CPR:hrlyPayRateStraightTime>
            <xsl:value-of select="format-number($bpc/PayCode/HourlyRate, '#.00')"/>
          </CPR:hrlyPayRateStraightTime>
          <CPR:hrlyPayRateOvertime>
            <xsl:value-of select="format-number($bpc/PayCode/HourlyRate * 1.5, '#.00')"/>
          </CPR:hrlyPayRateOvertime>
          <CPR:hrlyPayRateDoubletime>
            <xsl:value-of select="format-number($bpc/PayCode/HourlyRate * 2, '#.00')"/>
          </CPR:hrlyPayRateDoubletime>
        </CPR:hrlyPayRate>
        <CPR:grossAmountEarned>
          <CPR:thisProject>
            <xsl:value-of select="GrossWage"/>
          </CPR:thisProject>
          <CPR:allWork>
            <xsl:value-of select="GrossWage"/>
          </CPR:allWork>
        </CPR:grossAmountEarned>
        <CPR:deductionsContribPay>
          <CPR:fedTax>
            <xsl:value-of select="format-number(sum(Taxes/PayrollTax[Tax/Code='FIT']/Amount), '0.00')"/>
          </CPR:fedTax>
          <CPR:FICA>
            <xsl:value-of select="format-number(sum(Taxes/PayrollTax[Tax/Code='SS_Employee']/Amount), '0.00')"/>
          </CPR:FICA>
          <CPR:stateTax>
            <xsl:value-of select="format-number(sum(Taxes/PayrollTax[Tax/Code='SIT']/Amount), '0.00')"/>
          </CPR:stateTax>
          <CPR:SDI>
            <xsl:value-of select="format-number(sum(Taxes/PayrollTax[Tax/Code='SDI']/Amount), '0.00')"/>
          </CPR:SDI>
          <CPR:vacationHoliday>
            <xsl:value-of select="format-number(sum(PayTypes/PayrollPayType[PayType/Id=5]/Amount), '0.00')"/>
          </CPR:vacationHoliday>
          <CPR:healthWelfare>0.0</CPR:healthWelfare>
          <CPR:pension>0.0</CPR:pension>
          <CPR:training>
            <xsl:value-of select="format-number(sum(Taxes/PayrollTax[Tax/Code='ETT']/Amount), '0.00')"/>
          </CPR:training>
          <CPR:fundAdmin>0.0</CPR:fundAdmin>
          <CPR:dues>0.0</CPR:dues>
          <CPR:travelSubs>0.0</CPR:travelSubs>
          <CPR:savings>0.0</CPR:savings>
          <CPR:other>
            <xsl:value-of select="format-number(sum(PayTypes/PayrollPayType[PayType/Id!=5]/Amount), '0.00')"/>
          </CPR:other>
          <CPR:total>0.0</CPR:total>
          <CPR:notes>
            <xsl:value-of select="Notes"/>
          </CPR:notes>
        </CPR:deductionsContribPay>
        <CPR:netWagePaidWeek>
          <xsl:value-of select="NetWage"/>
        </CPR:netWagePaidWeek>
        <CPR:checkNum>
          <xsl:value-of select="CheckNumber"/>
        </CPR:checkNum>
      </CPR:payroll>
    </CPR:employee>
  </xsl:template>
  <xsl:template match="Company">
    <CPR:contractorInfo>
      <CPR:contractorName>
        <xsl:value-of select="TaxFilingName"/>
      </CPR:contractorName>
      <CPR:contractorLicense>
        <CPR:licenseType>
          <xsl:value-of select="../Project/LicenseType"/>
        </CPR:licenseType>
        <CPR:licenseNum>
          California Motor Carrier Permit: <xsl:value-of select="../Project/LicenseNo"/>
        </CPR:licenseNum>
      </CPR:contractorLicense>
      <CPR:contractorPWCR>NA</CPR:contractorPWCR>
      <CPR:contractorFEIN>
        <xsl:value-of select="FederalEIN"/>
      </CPR:contractorFEIN>
      <CPR:contractorAddress>
        <CPR:street>
          <xsl:value-of select="BusinessAddress/AddressLine1"/>
        </CPR:street>
        <CPR:city>
          <xsl:value-of select="BusinessAddress/City"/>
        </CPR:city>
        <CPR:state>
          <xsl:value-of select="BusinessAddress/StateCode"/>
        </CPR:state>
        <CPR:zip>
          <xsl:value-of select="BusinessAddress/Zip"/>
        </CPR:zip>
      </CPR:contractorAddress>
      <CPR:insuranceNum>
        <xsl:value-of select="../Project/PolicyNo"/>
      </CPR:insuranceNum>
      <CPR:contractorEmail></CPR:contractorEmail>
    </CPR:contractorInfo>
  </xsl:template>
  <xsl:template match="Project">
    <CPR:projectInfo>
      <CPR:awardingBody>
        <xsl:value-of select="AwardingBody"/>
      </CPR:awardingBody>
      <CPR:contractAgencyID/>
      <CPR:contractAgency></CPR:contractAgency>
      <CPR:projectName>
        <xsl:value-of select="ProjectName"/>
      </CPR:projectName>
      <CPR:projectID>
        <xsl:value-of select="ProjectId"/>
      </CPR:projectID>
      <CPR:awardingBodyID/>
      <CPR:projectNum/>
      <CPR:contractID>
        <xsl:value-of select="RegistrationNo"/>
      </CPR:contractID>
      <CPR:projectLocation>
        <CPR:description/>
        <CPR:street/>
        <CPR:city/>
        <CPR:county/>
        <CPR:state/>
        <CPR:zip/>
      </CPR:projectLocation>
    </CPR:projectInfo>
  </xsl:template>
</xsl:stylesheet>