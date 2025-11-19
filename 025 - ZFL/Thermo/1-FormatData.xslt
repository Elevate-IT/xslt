<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl MyScript"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output method="xml" indent="yes"/>
  <xsl:key name="Group-by-ExternalNo" match="//Line[starts-with(., 'POSIT|')]" use="MyScript:GetData(., 52)" />
  <xsl:template match="@* | node()">
    <xsl:apply-templates select="@* | node()"/>
  </xsl:template>
  <xsl:template match="/">
    <Message>
      <Header>
        <MessageID>
          <xsl:value-of select="MyScript:GetData(//Line[starts-with(., 'START|')], 1)" />
        </MessageID>
        <CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </CreationDateTime>
        <ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ProcesAction>
        <FromTradingPartner>K000145</FromTradingPartner>
        <ToTradingPartner>ZFL</ToTradingPartner>
      </Header>
      <DataReceipt>
        <xsl:apply-templates />
      </DataReceipt>
      <DataMMD>
        <xsl:for-each select="//Line[starts-with(., 'POSIT|')][count(. | key('Group-by-ExternalNo', MyScript:GetData(., 52))[1]) = 1]">
          <xsl:variable name="LineKey" select="MyScript:GetData(., 52)" />
          <xsl:if test="$LineKey != ''">
            <xsl:apply-templates select="."/>
          </xsl:if>
        </xsl:for-each>
      </DataMMD>
    </Message>
  </xsl:template>
  <xsl:template match="//Line[starts-with(., 'START|')]">
    <xsl:element name="START">
      <xsl:element name="MessageID">
        <xsl:value-of select="MyScript:GetData(., 1)"/>
      </xsl:element>
      <xsl:element name="Date">
        <xsl:value-of select="MyScript:GetData(., 2)"/>
      </xsl:element>
      <xsl:element name="OwnGLN">
        <xsl:value-of select="MyScript:GetData(., 3)"/>
      </xsl:element>
      <xsl:element name="OwnWinSped">
        <xsl:value-of select="MyScript:GetData(., 4)"/>
      </xsl:element>
      <xsl:element name="OwnName">
        <xsl:value-of select="MyScript:GetData(., 5)"/>
      </xsl:element>
      <xsl:element name="GLNEDI">
        <xsl:value-of select="MyScript:GetData(., 6)"/>
      </xsl:element>
      <xsl:element name="WinSpedEDI">
        <xsl:value-of select="MyScript:GetData(., 7)"/>
      </xsl:element>
      <xsl:element name="NameEDI">
        <xsl:value-of select="MyScript:GetData(., 8)"/>
      </xsl:element>
      <xsl:element name="Mapping">
        <xsl:value-of select="MyScript:GetData(., 10)"/>
      </xsl:element>
      <xsl:element name="Status">
        <xsl:value-of select="MyScript:GetData(., 11)"/>
      </xsl:element>
      <xsl:element name="VersionInfo">
        <xsl:value-of select="MyScript:GetData(., 12)"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="//Line[starts-with(., 'LADELI|')]">
    <xsl:element name="LADELI">
      <xsl:element name="MessageID">
        <xsl:value-of select="MyScript:GetData(., 1)"/>
      </xsl:element>
      <xsl:element name="LoadingListNo">
        <xsl:value-of select="MyScript:GetData(., 2)"/>
      </xsl:element>
      <xsl:element name="Truck">
        <xsl:value-of select="MyScript:GetData(., 3)"/>
      </xsl:element>
      <xsl:element name="Trailer">
        <xsl:value-of select="MyScript:GetData(., 4)"/>
      </xsl:element>
      <xsl:element name="DriverID">
        <xsl:value-of select="MyScript:GetData(., 5)"/>
      </xsl:element>
      <xsl:element name="DriverName">
        <xsl:value-of select="MyScript:GetData(., 6)"/>
      </xsl:element>
      <xsl:element name="CallOrder">
        <xsl:value-of select="MyScript:GetData(., 10)"/>
      </xsl:element>
      <xsl:element name="RouteNumber">
        <xsl:value-of select="MyScript:GetData(., 11)"/>
      </xsl:element>
      <xsl:element name="TruckType">
        <xsl:value-of select="MyScript:GetData(., 12)"/>
      </xsl:element>
      <xsl:element name="Export">
        <xsl:value-of select="MyScript:GetData(., 13)"/>
      </xsl:element>
      <xsl:element name="WebSpedTripID">
        <xsl:value-of select="MyScript:GetData(., 14)"/>
      </xsl:element>
      <xsl:element name="BorderoNo">
        <xsl:value-of select="MyScript:GetData(., 15)"/>
      </xsl:element>
      <xsl:element name="StartDate">
        <xsl:value-of select="MyScript:GetData(., 16)"/>
      </xsl:element>
      <xsl:element name="Telephone">
        <xsl:value-of select="MyScript:GetData(., 19)"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="//Line[starts-with(., 'AUFTR|')]">
    <xsl:element name="AUFTR">
      <xsl:element name="MessageID">
        <xsl:value-of select="MyScript:GetData(., 1)"/>
      </xsl:element>
      <xsl:element name="LoadingListNo">
        <xsl:value-of select="MyScript:GetData(., 2)"/>
      </xsl:element>
      <xsl:element name="WinSpedConsignmentNo">
        <xsl:value-of select="MyScript:GetData(., 3)"/>
      </xsl:element>
      <xsl:element name="DeliveryNoteNo">
        <xsl:value-of select="MyScript:GetData(., 4)"/>
      </xsl:element>
      <xsl:element name="DeliveryNoteInfo">
        <xsl:value-of select="MyScript:GetData(., 5)"/>
      </xsl:element>
      <xsl:element name="OrderDate">
        <xsl:value-of select="MyScript:FormatDate(MyScript:GetData(., 6))"/>
      </xsl:element>
      <xsl:element name="CustomerNo">
        <xsl:value-of select="MyScript:GetData(., 15)"/>
      </xsl:element>
      <xsl:element name="ConsignmentNo">
        <xsl:value-of select="MyScript:GetData(., 16)"/>
      </xsl:element>
      <xsl:element name="OrderTypeCode">
        <xsl:value-of select="MyScript:GetData(., 17)"/>
      </xsl:element>
      <xsl:element name="Incoterm">
        <xsl:value-of select="MyScript:GetData(., 18)"/>
      </xsl:element>
      <xsl:element name="ExternalDocumentNo">
        <xsl:value-of select="MyScript:GetData(., 32)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="MyScript:GetData(//Line[starts-with(., 'LADELI|')], 11)" />
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="//Line[starts-with(., 'POSIT|')]">
    <xsl:element name="POSIT">
      <xsl:element name="MessageID">
        <xsl:value-of select="MyScript:GetData(., 1)"/>
      </xsl:element>
      <xsl:element name="LoadingListNo">
        <xsl:value-of select="MyScript:GetData(., 2)"/>
      </xsl:element>
      <xsl:element name="WinSpedConsignmentNo">
        <xsl:value-of select="MyScript:GetData(., 3)"/>
      </xsl:element>
      <xsl:element name="PositionNo">
        <xsl:value-of select="MyScript:GetData(., 4)"/>
      </xsl:element>
      <xsl:element name="ActualWeight">
        <xsl:value-of select="MyScript:GetData(., 6)"/>
      </xsl:element>
      <xsl:element name="ChargeableWeight">
        <xsl:value-of select="MyScript:GetData(., 7)"/>
      </xsl:element>
      <xsl:element name="EAN">
        <xsl:value-of select="MyScript:GetData(., 8)"/>
      </xsl:element>
      <xsl:element name="ExternalNo">
        <xsl:value-of select="MyScript:GetData(., 52)"/>
      </xsl:element>
      <xsl:element name="ExternalBatchNo">
        <xsl:value-of select="substring(concat(MyScript:GetData(., 12), '-', MyScript:GetData(//Line[starts-with(., 'LADELI|')], 11)), 10)"/>
      </xsl:element>
      <xsl:element name="Description">
        <xsl:value-of select="MyScript:GetData(., 13)"/>
      </xsl:element>
      <xsl:element name="CarrierQuantity">
        <xsl:value-of select="MyScript:GetData(., 66)"/>
      </xsl:element>
      <xsl:element name="Quantity">
        <xsl:value-of select="MyScript:GetData(., 67)"/>
      </xsl:element>
      <xsl:element name="QtyPerCarrier">
        <xsl:value-of select="MyScript:GetData(., 59)"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="//Line[starts-with(., 'ADR|')]">
    <xsl:choose>
      <xsl:when test="MyScript:GetData(., 4) = '1'">
        <xsl:element name="ADR_1">
          <xsl:element name="MessageID">
            <xsl:value-of select="MyScript:GetData(., 1)"/>
          </xsl:element>
          <xsl:element name="LoadingListNo">
            <xsl:value-of select="MyScript:GetData(., 2)"/>
          </xsl:element>
          <xsl:element name="WinSpedConsignmentNo">
            <xsl:value-of select="MyScript:GetData(., 3)"/>
          </xsl:element>
          <xsl:element name="AddressType">
            <xsl:value-of select="MyScript:GetData(., 4)"/>
          </xsl:element>
          <xsl:element name="AddressNo">
            <xsl:value-of select="MyScript:GetData(., 5)"/>
          </xsl:element>
          <xsl:element name="GLN">
            <xsl:value-of select="MyScript:GetData(., 6)"/>
          </xsl:element>
          <xsl:element name="Name1">
            <xsl:value-of select="MyScript:GetData(., 7)"/>
          </xsl:element>
          <xsl:element name="Name2">
            <xsl:value-of select="MyScript:GetData(., 8)"/>
          </xsl:element>
          <xsl:element name="Street">
            <xsl:value-of select="MyScript:GetData(., 9)"/>
          </xsl:element>
          <xsl:element name="CountryCode">
            <xsl:value-of select="MyScript:GetData(., 10)"/>
          </xsl:element>
          <xsl:element name="PostalCode">
            <xsl:value-of select="MyScript:GetData(., 11)"/>
          </xsl:element>
          <xsl:element name="City">
            <xsl:value-of select="MyScript:GetData(., 12)"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="MyScript:GetData(., 4) = '5'">
        <xsl:element name="ADR_5">
          <xsl:element name="MessageID">
            <xsl:value-of select="MyScript:GetData(., 1)"/>
          </xsl:element>
          <xsl:element name="LoadingListNo">
            <xsl:value-of select="MyScript:GetData(., 2)"/>
          </xsl:element>
          <xsl:element name="WinSpedConsignmentNo">
            <xsl:value-of select="MyScript:GetData(., 3)"/>
          </xsl:element>
          <xsl:element name="AddressType">
            <xsl:value-of select="MyScript:GetData(., 4)"/>
          </xsl:element>
          <xsl:element name="Name">
            <xsl:value-of select="MyScript:GetData(., 7)"/>
          </xsl:element>
          <xsl:element name="MatchCode">
            <xsl:value-of select="MyScript:GetData(., 18)"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="MyScript:GetData(., 4) = '12'">
        <xsl:element name="ADR_12">
          <xsl:element name="MessageID">
            <xsl:value-of select="MyScript:GetData(., 1)"/>
          </xsl:element>
          <xsl:element name="LoadingListNo">
            <xsl:value-of select="MyScript:GetData(., 2)"/>
          </xsl:element>
          <xsl:element name="WinSpedConsignmentNo">
            <xsl:value-of select="MyScript:GetData(., 3)"/>
          </xsl:element>
          <xsl:element name="AddressType">
            <xsl:value-of select="MyScript:GetData(., 4)"/>
          </xsl:element>
          <xsl:element name="Name">
            <xsl:value-of select="MyScript:GetData(., 7)"/>
          </xsl:element>
          <xsl:element name="MatchCode">
            <xsl:value-of select="MyScript:GetData(., 18)"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[
      public string GetData(string input, int index)
      {
          return input.Split('|')[index];
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }   
      
      public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string FormatDate(string input) 
      {
        return input.Substring(0,4) + "-" + input.Substring(4, 2) + "-" + input.Substring(6, 2);
      }
    ]]>
  </msxsl:script>
</xsl:stylesheet>
