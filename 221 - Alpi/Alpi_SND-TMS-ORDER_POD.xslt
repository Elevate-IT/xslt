<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/sendtmsdocument:v1.00"
                exclude-result-prefixes="msxsl"
  >
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="/ns0:Message">
    <xsl:copy>
      <xsl:apply-templates select="ns0:Header"/>
      <xsl:apply-templates select="ns0:Documents"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ns0:Header">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ns0:Documents">
    <xsl:copy>
      <xsl:apply-templates select="ns0:Document"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ns0:Document">
    <xsl:copy>
      <xsl:apply-templates select="ns0:No | ns0:OrderTypeCode | ns0:ExternalDocumentNo | ns0:StatusCode | ns0:SectionConfigFilterCode |
                                  ns0:Attribute01 | ns0:FromAddressNo | ns0:FromAddressDescription | ns0:FromAddressStreet | ns0:FromAddressPostCode |
                                  ns0:FromAddressCity | ns0:FromAddressCountryCode | ns0:LoadingDateFrom | ns0:LoadReference | ns0:ToAddressNo | 
                                  ns0:ToAddressDescription | ns0:ToAddressStreet | ns0:ToAddressPostCode | ns0:ToAddressCity | ns0:ToAddressCountryCode |
                                  ns0:UnloadingDateFrom | ns0:ActualEndingDate"/>
      
      <xsl:apply-templates select="ns0:DocumentLines"/>
      
      <xsl:apply-templates select="ns0:LinkedDocuments"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ns0:DocumentLines">
    <xsl:copy>
      <xsl:apply-templates select="ns0:DocumentLine[ns0:Type = '1']"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ns0:DocumentLine">
    <xsl:copy>
      <xsl:apply-templates select="ns0:No | ns0:Description | ns0:Quantity | ns0:UnitofMeasureCode | ns0:GrossWeight |
                                  ns0:Volume"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>