<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl MyScript s0"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
    xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
>
  <xsl:output omit-xml-declaration="no" method="xml" version="1.0" />
  <xsl:key name="Group-by-ItemNo" match="//s0:DocumentLines/s0:DocumentLine[s0:Type = 1][s0:QtyPosted &gt; 0]" use="s0:No" />
  <xsl:key name="Group-by-ExBatchNo" match="//s0:DocumentDetailLines/s0:DocumentDetailLine" use="s0:ExternalBatchNo" />
  <xsl:decimal-format name="eur" decimal-separator="," grouping-separator="."/>
    <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <ShipConfirmPR>
      <ConfirmToCode>
        <xsl:value-of select="//s0:ToTradingPartner" />
      </ConfirmToCode>
      <ShippedFromLocationCode>1DANDOY</ShippedFromLocationCode>
      <OrderNo>
        <xsl:value-of select="s0:ExternalDocumentNo" />
      </OrderNo>
      <ExtOrderNo/>
      <YourReference/>
      <ShippingNo/>
      <ShipmentDate>
        <xsl:value-of select="MyScript:ParseDate(s0:PostingDate, 'yyyy-MM-dd', 'dd.MM.yyyy')" />
      </ShipmentDate>
      <ShipmentMethodCode/>
      <ShippingAgentCode>
        <xsl:choose>
          <xsl:when test="s0:CarrierAddress/s0:Name != ''">
            <xsl:value-of select="s0:CarrierAddress/s0:Name" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'SHIPAGENT']/s0:Value" />
          </xsl:otherwise>
        </xsl:choose>
      </ShippingAgentCode>
      <ShippingAgentServiceCode/>

      <xsl:if test="count(s0:DocumentLines/s0:DocumentLine[s0:Type = 1][s0:QtyPosted &gt; 0]) &gt; 0">
        <Positions>
          <xsl:for-each select="//s0:DocumentLine[s0:Type = 1][s0:QtyPosted &gt; 0][count(. | key('Group-by-ItemNo', s0:No)[1]) = 1]">
            <xsl:variable name="LineKey" select="s0:No" />
            <xsl:if test="s0:No != ''">
              <Position>
                <PositionNo>
                  <xsl:choose>
                    <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value != ''">
                      <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="s0:LineNo div 10000" />
                    </xsl:otherwise>
                  </xsl:choose>
                </PositionNo>
                <ItemNo>
                  <xsl:value-of select="s0:ExternalNo" />
                </ItemNo>
                <ErkNo>
                  <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'ERKNO']/s0:Value" />
                </ErkNo>
                <ItemEAN>
                  <xsl:value-of select="s0:EANCode" />
                </ItemEAN>
                <Description>
                  <xsl:value-of select="s0:Description" />
                </Description>
                <UnitOfMeasure>
                  <xsl:value-of select="s0:UnitofMeasureCode" />
                </UnitOfMeasure>
                <Quantity>
                  <xsl:value-of select="format-number(sum(key('Group-by-ItemNo',$LineKey)/s0:QtyPosted), '####,#', 'eur')" />
                </Quantity>
                <BaseUnitOfMeasure>
                  <xsl:value-of select="s0:BaseUnitofMeasureCode" />
                </BaseUnitOfMeasure>
                <QuantityBase>
                  <xsl:value-of select="format-number(sum(key('Group-by-ItemNo',$LineKey)/s0:QtyBasePosted), '####,#', 'eur')" />
                </QuantityBase>
                <xsl:for-each select="//s0:DocumentLine[s0:Type = 1][s0:QtyPosted &gt; 0]/s0:DocumentDetailLines/s0:DocumentDetailLine[s0:CustomerItemNo = $LineKey][s0:Posted = 1][count(. | key('Group-by-ExBatchNo', s0:ExternalBatchNo)[1]) = 1]">
                  <xsl:variable name="LineKey2" select="s0:ExternalBatchNo" />
                  <xsl:if test="s0:ExternalBatchNo != ''">
                    <Lot>
                      <LotNo>
                        <xsl:value-of select="s0:ExternalBatchNo" />
                      </LotNo>
                      <ProductionDate>
                        <xsl:if test="s0:ProductionDate != ''">
                          <xsl:value-of select="MyScript:ParseDate(s0:ProductionDate, 'yyyy-MM-dd', 'dd.MM.yy')" />
                        </xsl:if>
                      </ProductionDate>
                      <Quantity_Base>
                        <xsl:value-of select="format-number(sum(key('Group-by-ExBatchNo',$LineKey2)/s0:QuantityBase), '####,#', 'eur')" />
                      </Quantity_Base>
                    </Lot>
                  </xsl:if>
                </xsl:for-each>
              </Position>
            </xsl:if>
          </xsl:for-each>
        </Positions>
      </xsl:if>
    </ShipConfirmPR>
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