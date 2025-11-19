<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
    xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
>
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  <xsl:variable name='newline'>
    <xsl:text>&#xa;</xsl:text>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <BL>
      <BL1>
        <xsl:value-of select="substring(concat('BL', '   '), 1, 3)" />
      </BL1>
      <BL2>
        <xsl:value-of select="substring(concat(s0:ExternalDocumentNo, '              '), 1, 14)" />
      </BL2>
      <BL3>
        <xsl:value-of select="substring(concat(MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'yyyyMMddHHmmss'), '              '), 1, 14)" />
      </BL3>
      <BL4>
        <xsl:value-of select="substring(concat(MyScript:ParseDate(s0:PostingDate, 'yyyy-MM-dd', 'yyyyMMddHHmmss'), '              '), 1, 14)" />
      </BL4>
      <BL5>
        <xsl:value-of select="$newline" />
      </BL5>
    </BL>

    <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type = 1]">
      <LL>
        <LL1>
          <xsl:value-of select="substring(concat('LL', '   '), 1, 3)" />
        </LL1>
        <LL2>
          <xsl:value-of select="substring(concat(../../s0:ExternalDocumentNo, '              '), 1, 14)" />
        </LL2>
        <LL3>
          <xsl:choose>
            <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value != ''">
              <xsl:value-of select="format-number(s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value, '000')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(s0:LineNo div 10000, '000')" />
            </xsl:otherwise>
          </xsl:choose>
        </LL3>
        <LL4>
          <xsl:value-of select="substring(concat('', '              '), 1, 14)" />
        </LL4>
        <LL5>
          <xsl:value-of select="substring(concat(s0:ExternalNo, '      '), 1, 6)" />
        </LL5>
        <LL6>
          <xsl:value-of select="substring(concat('           ', format-number(s0:QtyPosted, '#.000')*1000), string-length(format-number(s0:QtyPosted, '#.000')*1000)+1, string-length(format-number(s0:QtyPosted, '#.000')*1000)+11)"/>
        </LL6>
        <LL7>
          <xsl:value-of select="$newline" />
        </LL7>
      </LL>
    </xsl:for-each>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
		]]>
  </msxsl:script>
</xsl:stylesheet>