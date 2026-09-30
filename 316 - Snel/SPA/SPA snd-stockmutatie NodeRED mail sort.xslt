<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
                xmlns:s0="urn:schemas-microsoft-com:office:spreadsheet">
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:key name="GroupBy-ActieCode_TaakNr_Productcode_Redencode_SSCC_Lotnr_THT" match="//s0:Row[@name = 'Content']"
    use="concat(s0:Cell[@name = 'ActieCode']/s0:Data, '-', s0:Cell[@name = 'Taak_Nr']/s0:Data, '-', s0:Cell[@name = 'Productcode']/s0:Data, '-', s0:Cell[@name = 'Redencode']/s0:Data, '-', s0:Cell[@name = 'SSCC']/s0:Data, '-', s0:Cell[@name = 'Lotnr']/s0:Data, '-', s0:Cell[@name = 'THT']/s0:Data)" />
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="s0:Table">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      
      <xsl:for-each select="s0:Column">
        <xsl:copy>
          <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
      </xsl:for-each>
      
      
      <xsl:for-each select="s0:Row[@name = 'Header']">
        <xsl:copy>
          <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
      </xsl:for-each>
      
      <xsl:for-each select="s0:Row[@name = 'Content'][count(. | key('GroupBy-ActieCode_TaakNr_Productcode_Redencode_SSCC_Lotnr_THT', concat(s0:Cell[@name = 'ActieCode']/s0:Data, '-', s0:Cell[@name = 'Taak_Nr']/s0:Data, '-', s0:Cell[@name = 'Productcode']/s0:Data, '-', s0:Cell[@name = 'Redencode']/s0:Data, '-', s0:Cell[@name = 'SSCC']/s0:Data, '-', s0:Cell[@name = 'Lotnr']/s0:Data, '-', s0:Cell[@name = 'THT']/s0:Data))[1]) = 1]">
        <xsl:sort select="s0:Cell[@name = 'InitialSort']/s0:Data" data-type="number" />
        <xsl:sort select="s0:Cell[@name = 'Colli']/s0:Data" data-type="number" />
        <xsl:sort select="s0:Cell[@name = 'Datum_creatie']/s0:Data" />
        <xsl:sort select="s0:Cell[@name = 'Tijd_creatie']/s0:Data" />
        <xsl:variable name="LineKey" select="concat(s0:Cell[@name = 'ActieCode']/s0:Data, '-', s0:Cell[@name = 'Taak_Nr']/s0:Data, '-', s0:Cell[@name = 'Productcode']/s0:Data, '-', s0:Cell[@name = 'Redencode']/s0:Data, '-', s0:Cell[@name = 'SSCC']/s0:Data, '-', s0:Cell[@name = 'Lotnr']/s0:Data, '-', s0:Cell[@name = 'THT']/s0:Data)" />
        <xsl:if test="$LineKey != '------'">
          <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:for-each select="node()">
              <xsl:choose>
                <xsl:when test="@name = 'InitialSort'">
                  <!--skip node-->
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:choose>
                      <xsl:when test="@name = 'Colli'">
                        <xsl:for-each select="node()">
                          <xsl:copy>
                            <xsl:apply-templates select="@*"/>
                            <xsl:value-of select="sum(key('GroupBy-ActieCode_TaakNr_Productcode_Redencode_SSCC_Lotnr_THT',$LineKey)/s0:Cell[@name = 'Colli']/s0:Data)" />
                          </xsl:copy>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates select="@* | node()"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:copy>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:copy>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
