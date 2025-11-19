<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:functx="http://my/functions"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all" >
  
  <xsl:output method="text" />
  
  <xsl:template match="//Message">
      <xsl:apply-templates select="Customers/Customer" />
  </xsl:template>

  <xsl:template match="Customer">
      <xsl:if test="position() &gt; 1">
        <xsl:text>&#xa;</xsl:text> <!--  new line -->
      </xsl:if>
      
      <xsl:variable name="ToTradingPartner" select="tokenize(../../Header/ToTradingPartner, ':')"/>
      
      <xsl:variable name="Language">
        <xsl:choose>
          <xsl:when test="substring(LanguageCode, 1, 2) = ('EN', 'NL', 'FR', 'DE', 'IT', 'ES')">
            <xsl:value-of select="substring(LanguageCode, 1, 2)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>EN</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="VATNumber">
        <xsl:choose>
          <xsl:when test="EnterpriseNo != ''">
            <xsl:value-of select="concat('BE', translate(EnterpriseNo, 'BE', ''))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="VATRegistrationNo" />
          </xsl:otherwise>
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

      <xsl:value-of select="functx:pad-string-left($ToTradingPartner[1], '0', 7)" />
      <xsl:value-of select="functx:pad-string-left($ToTradingPartner[2], '0', 3)" />
      <xsl:value-of select="functx:pad-string-right(No, ' ', 30)" />
      <xsl:value-of select="functx:pad-string-right(Name, ' ', 50)" />
      <xsl:value-of select="functx:pad-string-right(Address, ' ', 40)" />
      <xsl:value-of select="functx:pad-string-right(Address2, ' ', 40)" />
      <xsl:value-of select="functx:pad-string-right('', ' ', 40)" />
      <xsl:value-of select="functx:pad-string-right(PostCode, ' ', 12)" />
      <xsl:value-of select="functx:pad-string-right(City, ' ', 50)" />
      <xsl:value-of select="functx:pad-string-right(County, ' ', 50)" />
      <xsl:value-of select="functx:pad-string-right(CountryRegionCode, ' ', 2)" />
      <xsl:value-of select="functx:pad-string-right(translate(PhoneNo, '/.', '  '), ' ', 20)" />
      <xsl:value-of select="functx:pad-string-right(translate(FaxNo, '/.', '  '), ' ', 20)" />
      <xsl:value-of select="functx:pad-string-right(E-Mail, ' ', 50)" />
      <xsl:value-of select="functx:pad-string-right('', ' ', 30)" />
      <xsl:value-of select="functx:pad-string-right('', ' ', 30)" />
      <xsl:value-of select="functx:pad-string-right($Language, ' ', 2)" />
      <xsl:value-of select="functx:pad-string-right(translate($VATNumber, ' .', ''), ' ', 50)" />
      <xsl:value-of select="functx:pad-string-right('', ' ', 50)" />
      <xsl:value-of select="functx:pad-string-right('', ' ', 50)" />
      <xsl:choose>
        <xsl:when test="count(CreditLimitLCY) = 0">
          <xsl:value-of select="functx:pad-string-right('0', ' ', 17)" />
        </xsl:when>
        <xsl:when test="CreditLimitLCY = ''">
          <xsl:value-of select="functx:pad-string-right('0', ' ', 17)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="functx:pad-string-right(format-number(CreditLimitLCY, '#'), ' ', 17)" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="functx:pad-string-right($Currency, ' ', 3)" />
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
