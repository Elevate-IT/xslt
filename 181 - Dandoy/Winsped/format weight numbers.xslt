<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"  />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="s0:TareWeight | s0:GrossWeight | s0:NetWeight | s0:VolumeWeight | s0:TareWeightperUoM | s0:GrossWeightperUoM | s0:NetWeightperUoM | s0:FinishedNetWeight | s0:RemainingNetWeight | s0:GrossWeightOutstanding | s0:NetWeightOutstanding">
    <xsl:copy>
      <xsl:value-of select="format-number(.,'0.##')" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
