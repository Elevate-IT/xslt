<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl MyScript"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Header']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <xsl:element name="MessageCreationDate">
        <xsl:value-of select="MyScript:ParseDate(*[local-name() = 'CreationDateTime'], 's', 'yyyyMMdd')" />
      </xsl:element>
      <xsl:element name="MessageCreationTime">
        <xsl:value-of select="MyScript:ParseDate(*[local-name() = 'CreationDateTime'], 's', 'hhmmss')" />      
      </xsl:element>
    </xsl:copy>
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
