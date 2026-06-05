<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:functx="http://my/functions"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all" >
  
  <xsl:output method="text" />
  
  <xsl:decimal-format name="Amount" decimal-separator="," grouping-separator="."/>
  
  <xsl:template match="//Message">
    <xsl:apply-templates select="CustomerLedgerEntries/CustomerLedgerEntry" />
    <xsl:apply-templates select="Summary" />
  </xsl:template>
  
  <xsl:template match="CustomerLedgerEntry">
    <xsl:variable name="ToTradingPartner" select="tokenize(../../Header/ToTradingPartner, ':')"/>

    <xsl:variable name="DocumentType">
      <xsl:choose>
        <xsl:when test="DocumentType = '2'"> <!-- "Invoice" -->
          <xsl:text>+</xsl:text>
        </xsl:when>
        <xsl:when test="DocumentType = '3'"> <!-- "Credit Memo" -->
          <xsl:text>-</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="Currency">
      <xsl:choose>
        <xsl:when test="CurrencyCode != ''">
          <xsl:value-of select="CurrencyCode" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>EUR</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:value-of select="functx:pad-string-right('1000', '', 4)" />
    <xsl:value-of select="functx:pad-string-left($ToTradingPartner[1], '0', 7)" />
    <xsl:value-of select="functx:pad-string-left($ToTradingPartner[2], '0', 3)" />
    <xsl:value-of select="functx:pad-string-right(CustomerNo, ' ', 30)" />
    <xsl:value-of select="functx:pad-string-right(DocumentNo, ' ', 15)" />
    <xsl:value-of select="functx:pad-string-right(format-date(DocumentDate, '[D01][M01][Y0001]'), ' ', 8)" />
    <xsl:value-of select="functx:pad-string-left(format-number(AbsoluteRemainingAmount, '0000000000000,00', 'Amount'), '0', 16)" />
    <xsl:value-of select="functx:pad-string-right($DocumentType, ' ', 1)" />
    <xsl:value-of select="functx:pad-string-right(format-date(DueDate, '[D01][M01][Y0001]'), ' ', 8)" />
    <xsl:value-of select="functx:pad-string-right($Currency, ' ', 3)" />
    
    <xsl:text>&#xa;</xsl:text> <!--  new line -->
  </xsl:template>
  
  <xsl:template match="Summary">
    <xsl:value-of select="functx:pad-string-right('2000', ' ', 4)" />
    <xsl:value-of select="functx:pad-string-right(NrOfRecords, ' ', 10)" />
    <xsl:value-of select="functx:pad-string-left(format-number(TotalAbsoluteRemainingAmount, '0000000000000,00', 'Amount'), '0', 16)" />
  </xsl:template>
  
  <xsl:function name="functx:pad-string-right" as="xsd:string">
    <xsl:param name="stringToPad" as="xsd:string?"/>
    <xsl:param name="padChar" as="xsd:string"/>
    <xsl:param name="length" as="xsd:integer"/>
    <xsl:sequence select="
      substring(
        string-join (
          (upper-case($stringToPad), for $i in (1 to $length) return $padChar)
          ,'')
        ,1,$length)" />
  </xsl:function>
  
  <xsl:function name="functx:pad-string-left" as="xsd:string">
    <xsl:param name="stringToPad" as="xsd:string?"/>
    <xsl:param name="padChar" as="xsd:string"/>
    <xsl:param name="length" as="xsd:integer"/>
    <xsl:sequence select="
      substring(
        string-join (
          (for $i in (1 to ($length - string-length($stringToPad))) return $padChar, upper-case($stringToPad))
          ,'')
        ,1,$length)" />
  </xsl:function>
  
</xsl:stylesheet>
