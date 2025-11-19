<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl MyScript s0" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <Dossiers>
      <Dossier>
        <Customer>
          <xsl:value-of select="s0:Customer/s0:No" />
        </Customer>
        <Date>
          <xsl:value-of select="MyScript:ParseDate(s0:DeliveryDate, 'yyyy-MM-dd', 'yyyy/MM/dd')" />
        </Date>
        <Reference>
          <xsl:choose>
            <xsl:when test="s0:ExternalDocumentNo != ''">
              <xsl:value-of select="substring(s0:ExternalDocumentNo, 1, 40)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="s0:No" />
            </xsl:otherwise>
          </xsl:choose>
        </Reference>
        <TransportType>
          <xsl:text>WMS</xsl:text>
        </TransportType>
        <Type>
          <xsl:text>R</xsl:text>
        </Type>
        <CallOffId>
          <xsl:value-of select="s0:No" />
        </CallOffId>
        <Action>
          <xsl:text>0</xsl:text>
        </Action>
        <Missions>
          <Mission>
            <SequenceNumber>
              <xsl:text>1</xsl:text>
            </SequenceNumber>
            <Instructions>
              <xsl:value-of select="substring(s0:ExternalReference, 1, 999)" />
            </Instructions>
            <xsl:if test="s0:Attribute02 = 'JA'">
              <Resource>
                <xsl:text>Kooiaap</xsl:text>
              </Resource>
            </xsl:if>
            <Load>
              <Name>
                <xsl:value-of select="substring(s0:SenderAddress/s0:Name, 1, 35)" />
              </Name>
              <Street>
                <xsl:value-of select="substring(s0:SenderAddress/s0:Address, 1, 60)" />
              </Street>
              <xsl:if test="s0:SenderAddress/s0:AddressNo != ''">
                <HouseNbr>
                  <xsl:value-of select="substring(s0:SenderAddress/s0:AddressNo, 1, 7)" />
                </HouseNbr>
              </xsl:if>
              <Country>
                <xsl:value-of select="substring(s0:SenderAddress/s0:CountryRegionCode, 1, 20)" />
              </Country>
              <ZipCode>
                <xsl:value-of select="substring(s0:SenderAddress/s0:PostCode, 1, 10)" />
              </ZipCode>
              <City>
                <xsl:value-of select="substring(s0:SenderAddress/s0:City, 1, 100)" />
              </City>
              <Date>
                <xsl:value-of select="MyScript:ParseDate(s0:EstimatedDepartureDate, 'yyyy-MM-dd', 'yyyy/MM/dd')" />
              </Date>
              <Reference>
                <xsl:value-of select="s0:No" />
              </Reference>
              <InfoTraject>
                <xsl:value-of select="s0:LocationNo" />
              </InfoTraject>
            </Load>
            <Unload>
              <Number>
                <xsl:value-of select="substring(s0:ShipToAddress/s0:No, 1, 15)" />
              </Number>
              <Name>
                <xsl:value-of select="substring(s0:ShipToAddress/s0:Name, 1, 35)" />
              </Name>
              <Street>
                <xsl:value-of select="substring(s0:ShipToAddress/s0:Address, 1, 60)" />
              </Street>
              <xsl:if test="s0:ShipToAddress/s0:AddressNo != ''">
                <HouseNbr>
                  <xsl:value-of select="substring(s0:ShipToAddress/s0:AddressNo, 1, 7)" />
                </HouseNbr>
              </xsl:if>
              <xsl:if test="s0:ShipToAddress/s0:Address2 != ''">
                <Street2>
                  <xsl:value-of select="substring(s0:ShipToAddress/s0:Address2, 1, 60)" />
                </Street2>
              </xsl:if>
              <Country>
                <xsl:value-of select="substring(s0:ShipToAddress/s0:CountryRegionCode, 1, 20)" />
              </Country>
              <ZipCode>
                <xsl:value-of select="substring(s0:ShipToAddress/s0:PostCode, 1, 10)" />
              </ZipCode>
              <City>
                <xsl:value-of select="substring(s0:ShipToAddress/s0:City, 1, 100)" />
              </City>
              <Date>
                <xsl:value-of select="MyScript:ParseDate(s0:DeliveryDate, 'yyyy-MM-dd', 'yyyy/MM/dd')" />
              </Date>
              <Reference>
                <xsl:value-of select="substring(s0:ExternalDocumentNo, 1, 100)" />
              </Reference>
            </Unload>
            <Products>
              <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type = '1']">
                <Product>
                  <SequenceNumber>
                    <xsl:value-of select="position() * 10" />
                  </SequenceNumber>
                  <Description>
                    <xsl:value-of select="s0:Description" />
                  </Description>
                  <Colli>
                    <xsl:value-of select="s0:CarrierQuantity" />
                  </Colli>
                  <Packaging>
                    <xsl:value-of select="s0:CarrierTypeCode" />
                  </Packaging>
                  <xsl:if test="s0:GrossWeight != '0'">
                    <Weight>
                      <xsl:value-of select="s0:GrossWeight" />
                    </Weight>
                  </xsl:if>
                  <Reference>
                    <xsl:value-of select="s0:ExternalNo" />
                  </Reference>
                </Product>
              </xsl:for-each>
            </Products>
          </Mission>
        </Missions>
      </Dossier>
    </Dossiers>
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