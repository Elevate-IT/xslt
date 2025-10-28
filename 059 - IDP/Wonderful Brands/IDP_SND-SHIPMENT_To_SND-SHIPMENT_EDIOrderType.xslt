<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ns0="www.boltrics.nl/sendshipment:v1.00"
>
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ns0:Document/ns0:Attributes/ns0:Attribute[ns0:Code = 'ORDERTYPE']/ns0:Value">
      <ns0:EDIOrderType>
        <xsl:value-of select="current()" />
      </ns0:EDIOrderType>
    </xsl:template>
</xsl:stylesheet>
