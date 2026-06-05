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

    <xsl:template match="//ns0:Document/ns0:ShipToAddress/ns0:Name">
      <ns0:ShipToName>
        <xsl:value-of select="current()" />
      </ns0:ShipToName>
    </xsl:template>
</xsl:stylesheet>
