<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendtransfer:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="3.0">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="/s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  
  <xsl:key
    name="kByEdiLineNo"
    match="s0:DocumentLine[s0:Type='1']"
    use="s0:Attributes/s0:Attribute[s0:Code='EDILINENO']/s0:Value"/>
  
  <xsl:template match="/s0:Message/s0:Documents/s0:Document">
    <!-- for each inbound edi line no -->
    <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type='1'][generate-id() = generate-id( key('kByEdiLineNo',s0:Attributes/s0:Attribute[s0:Code='EDILINENO']/s0:Value)[1])]">
      <xsl:text>HELARG    TVA  DA</xsl:text>
      <xsl:value-of select="concat(//s0:Document/s0:ExternalDocumentNo, codepoints-to-string(for $i in 1 to (20 - string-length(//s0:Document/s0:ExternalDocumentNo)) return 32))"/> 
      <xsl:value-of select="format-date(current-date(), '[Y0001][M01][D01]')" />
      <xsl:value-of select="format-date(//s0:Document/s0:DocumentDate, '[Y0001][M01][D01]')"/>
      <xsl:value-of select="format-date(//s0:Document/s0:DeliveryDate, '[Y0001][M01][D01]')"/>
      <xsl:value-of select="codepoints-to-string(for $i in 1 to 70 return 32)"/> 
      <xsl:value-of select="codepoints-to-string(for $i in 1 to 35 return 32)"/> 
      <xsl:value-of select="concat(//s0:Document/s0:ExternalReference, codepoints-to-string(for $i in 1 to (9 - string-length(//s0:Document/s0:ExternalReference)) return 32))"/> 
      <xsl:value-of select="substring(s0:Attributes/s0:Attribute[s0:Code='EDILINENO']/s0:Value, string-length(s0:Attributes/s0:Attribute[s0:Code='EDILINENO']/s0:Value) - 1)"/>
      <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code='EDILINENO']/s0:Value"/>
      <xsl:value-of select="concat(s0:ExternalNo, codepoints-to-string(for $i in 1 to (18 - string-length(s0:ExternalNo)) return 32))"/>
      <xsl:value-of select="concat(s0:Description, codepoints-to-string(for $i in 1 to (40 - string-length(s0:Description)) return 32))"/>
      <xsl:value-of select="format-number(number(s0:QtyPosted), '000000000')" />
      <xsl:text>PCE </xsl:text>
      <xsl:value-of select="concat(s0:Attribute01, codepoints-to-string(for $i in 1 to (10 - string-length(s0:Attribute01)) return 32))"/>
      <xsl:value-of select="codepoints-to-string(for $i in 1 to 20 return 32)"/> 
      <xsl:value-of select="codepoints-to-string(for $i in 1 to 12 return 32)"/> 
      <xsl:value-of select="codepoints-to-string(for $i in 1 to 3 return 32)"/> 
      <xsl:text>X</xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each> 
  </xsl:template>
</xsl:stylesheet>