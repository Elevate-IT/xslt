<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/stockadjustment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl s0 MyScript" version="3.0">
  
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes" />

  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Adjustments" />
  </xsl:template>

  <xsl:template match="//s0:Adjustments">
    <VIO-ACK>
      <UNH>
        <ReleaseId>1.1.0</ReleaseId>
        <ReleaseDate>2020-09-03T00:00:00</ReleaseDate>
        <Sender>72019</Sender>
        <Receiver>
          <xsl:value-of select="//s0:Header/s0:ToTradingPartner" />
        </Receiver>
        <MessageId>
          <xsl:choose>
            <xsl:when test="//s0:Header/s0:UniqueMessageNumber != ''">
              <xsl:value-of select="format-number(//s0:Header/s0:UniqueMessageNumber, '0000000')" />
              <!--<xsl:value-of select="//s0:Header/s0:UniqueMessageNumber" />-->
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(//s0:Header/s0:MessageID, '0000000')" />
            </xsl:otherwise>
          </xsl:choose>
        </MessageId>
        <MessageDate>
          <xsl:value-of select="format-dateTime(//s0:Header/s0:CreationDateTime, '[Y0001][M01][D01]')"/>
        </MessageDate>
        <MessageTime>
          <xsl:value-of select="format-dateTime(//s0:Header/s0:CreationDateTime, '[H01][m01][s01]')"/>
        </MessageTime>
        <MessageType>
          <xsl:text>Confirm</xsl:text>
        </MessageType>
        <MessageName>
          <xsl:text>VIO-ACK</xsl:text>
        </MessageName>
      </UNH>
      <xsl:for-each select="s0:Adjustment[s0:MutationType = 'Positive']">
        <StockData>
          <PalletSSCCcode>
            <xsl:value-of select="s0:Carrier/s0:No" />
          </PalletSSCCcode>
          <Type>
            <xsl:choose>
              <xsl:when test="s0:Carrier/s0:StatusCode = '90-GEBLOKKEERD'">
                <xsl:text>No reason provided</xsl:text>
              </xsl:when>
              <xsl:when test="s0:Carrier/s0:StatusCode = '99-RETOUR'">
                <xsl:text>No reason provided</xsl:text>
              </xsl:when>
              <xsl:when test="s0:Carrier/s0:StatusCode = '91-COMPRESSIE'">
                <xsl:text>Compressie</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Confirm</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </Type>
          <DestinationWarehouse>
            <xsl:choose>
              <xsl:when test="s0:BuildingCode = 'VOORKAAI'">
                <xsl:choose>
                  <xsl:when test="s0:LocationNo = 'P394'">
                    <xsl:text>P394</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>1993</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="s0:BuildingCode = 'BL'">
                <xsl:text>900</xsl:text>
              </xsl:when>
              <xsl:when test="s0:BuildingCode = 'TURNHOUT 1'">
                <xsl:text>100</xsl:text>
              </xsl:when>
            </xsl:choose>
          </DestinationWarehouse>
        </StockData>
      </xsl:for-each>
    </VIO-ACK>
  </xsl:template>
</xsl:stylesheet>