<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  
  <xsl:output method="xml" indent="yes" />
  
  <xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"  />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/ZDLVRY/IDOC/E1EDL20/E1ADRM1[PARTNER_Q = 'WE']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"  />
    </xsl:copy>
    
    <xsl:element name="IS_STO">
      <xsl:value-of select="PARTNER_ID = 'X5622'"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="*">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"  />
        </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
