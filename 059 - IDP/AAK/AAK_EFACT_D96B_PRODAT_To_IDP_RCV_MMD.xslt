<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/materialmasterdata:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="Xml">
    <Messages>
      <xsl:apply-templates select="Item/s0:EFACT_D96B_PRODAT" />
    </Messages>
  </xsl:template>
  <xsl:template match="text()" name="getCondition">
    <xsl:param name="pText" select="."/>
    <xsl:choose>
      <xsl:when test="$pText = '09'">
        <xsl:text>GEKOELD9</xsl:text>
      </xsl:when>
      <xsl:when test="$pText = '15'">
        <xsl:text>GEKOELD15</xsl:text>
      </xsl:when>
      <xsl:when test="$pText = '20'">
        <xsl:text>GEKOELD20</xsl:text>
      </xsl:when>
      <xsl:when test="$pText = 'AB'">
        <xsl:text>AMBIENT</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('GEKOELD', format-number(s0:MEA_2[MEA01 = 'SO']/s0:C502_3[C50201 = 'TC']/C50203,'#'))" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="s0:EFACT_D96B_PRODAT">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/UNH1" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701 = '137']/C50702,'yyyyMMddHHmm','s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="normalize-space(UNB/UNB2.1)" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="normalize-space(UNB/UNB2.2)" />
        </ns0:ToTradingPartner>
      </ns0:Header>

      <ns0:CustomerItems>
        <xsl:for-each select="s0:LINLoop1">
          <ns0:CustomerItem>
            <ns0:No2>
              <xsl:value-of select="s0:PIA_2[PIA01='1']/s0:C212_7/C21201"/>
            </ns0:No2>
            <ns0:Description>
              <xsl:choose>
                <xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304 != ''">
                  <xsl:value-of select="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='NL']/C27304 != ''">
                      <xsl:value-of select="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='NL']/C27304"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="s0:IMDLoop1/s0:IMD_2/s0:C273_2/C27304"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </ns0:Description>
            <ns0:SearchDescription>
              <xsl:choose>
                <xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304 != ''">
                  <xsl:value-of select="concat(s0:PIA_2[PIA01='1']/s0:C212_7/C21201, ' - ', s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(s0:PIA_2[PIA01='1']/s0:C212_7/C21201, ' - ', s0:IMDLoop1/s0:IMD_2/s0:C273_2/C27304)"/>
                </xsl:otherwise>
              </xsl:choose>
            </ns0:SearchDescription>
            <ns0:Description2>
              <xsl:choose>
                <xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304 != ''">
                  <xsl:value-of select="concat(s0:PIA_2[PIA01='1']/s0:C212_7/C21201, ' - ', s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(s0:PIA_2[PIA01='1']/s0:C212_7/C21201, ' - ', s0:IMDLoop1/s0:IMD_2/s0:C273_2/C27304)"/>
                </xsl:otherwise>
              </xsl:choose>
            </ns0:Description2>
            <ns0:BaseUnitofMeasure>
              <xsl:value-of select="s0:HAN[s0:C524/C52401 = 'WU']/s0:C218/C21801" />
            </ns0:BaseUnitofMeasure>
            <ns0:ItemCategoryCode>
              <xsl:text>MARGARINE</xsl:text>
            </ns0:ItemCategoryCode>
            <ns0:ProductGroupCode>
              <xsl:text>MARGARINE</xsl:text>
            </ns0:ProductGroupCode>
            <ns0:TariffNo>
              <xsl:value-of select="s0:PIA_2[PIA01 = '5']/s0:C212_7[C21202 = 'CC']/C21201" />
            </ns0:TariffNo>
            <ns0:CarrierTypeCodeReceipt>
              <xsl:value-of select="s0:PACLoop1/s0:PAC[PAC01 = '1']/s0:C202/C20201" />
            </ns0:CarrierTypeCodeReceipt>
            <ns0:CarrierTypeCodeShipment>
              <xsl:value-of select="s0:PACLoop1/s0:PAC[PAC01 = '1']/s0:C202/C20201" />
            </ns0:CarrierTypeCodeShipment>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:PIA_2[PIA01='1']/s0:C212_7/C21201"/>
            </ns0:ExternalNo>
            <xsl:if test="s0:DTM_5/s0:C507_5[C50701 = '363']/C50702 != ''">
              <ns0:ExpirationCalculation>
                <xsl:value-of select="concat(s0:DTM_5/s0:C507_5[C50701 = '363']/C50702, 'D')" />
              </ns0:ExpirationCalculation>
            </xsl:if>
            <xsl:if test="s0:DTM_5/s0:C507_5[C50701 = '364']/C50702 != ''">
              <ns0:ExpirationWarningCalculation>
                <xsl:value-of select="concat(s0:DTM_5/s0:C507_5[C50701 = '364']/C50702, 'D')" />
              </ns0:ExpirationWarningCalculation>
            </xsl:if>
            <xsl:if test="s0:DTM_5/s0:C507_5[C50701 = 'ZZZ']/C50702">
              <ns0:ReceiptQuarantaineDuration>
                <xsl:value-of select="concat(s0:DTM_5/s0:C507_5[C50701 = 'ZZZ']/C50702, 'D')" />
              </ns0:ReceiptQuarantaineDuration>
            </xsl:if>
            <xsl:if test="s0:MEA_2[MEA01 = 'SO']/s0:C502_3[C50201 = 'TC']/C50203 != ''">
              <xsl:variable name="temperature">
                <xsl:value-of select="s0:MEA_2[MEA01 = 'SO']/s0:C502_3[C50201 = 'TC']/C50203" />
              </xsl:variable>
              <ns0:ConditionatReceipt>
                <xsl:call-template name="getCondition">
                  <xsl:with-param name="pText" select="$temperature"/>
                </xsl:call-template>
              </ns0:ConditionatReceipt>
              <ns0:HandlingatReceipt>
                <xsl:text>PALLET</xsl:text>
              </ns0:HandlingatReceipt>
              <ns0:ConditionatShipment>
                <xsl:call-template name="getCondition">
                  <xsl:with-param name="pText" select="$temperature"/>
                </xsl:call-template>
              </ns0:ConditionatShipment>
              <ns0:HandlingatShipment>
                <xsl:text>PALLET</xsl:text>
              </ns0:HandlingatShipment>
              <ns0:ConditionatStorage>
                <xsl:call-template name="getCondition">
                  <xsl:with-param name="pText" select="$temperature"/>
                </xsl:call-template>
              </ns0:ConditionatStorage>
            </xsl:if>
            <ns0:UnitofMeasureatReceipt>
              <xsl:value-of select="s0:HAN[s0:C524/C52401 = 'WU']/s0:C218/C21801" />
            </ns0:UnitofMeasureatReceipt>
            <ns0:UnitofMeasureatShipment>
              <xsl:value-of select="s0:HAN[s0:C524/C52401 = 'WU']/s0:C218/C21801" />
            </ns0:UnitofMeasureatShipment>
            <ns0:UnitofMeasureatStorage>
              <xsl:value-of select="s0:HAN[s0:C524/C52401 = 'WU']/s0:C218/C21801" />
            </ns0:UnitofMeasureatStorage>
            <ns0:UnitofMeasureatOrdering>
              <xsl:value-of select="s0:HAN[s0:C524/C52401 = 'WU']/s0:C218/C21801" />
            </ns0:UnitofMeasureatOrdering>
            <xsl:if test="s0:MEA_2[MEA01 = 'SO']/s0:C502_3[C50201 = 'TC']/C50203 != ''">
              <ns0:Attribute03>
                <xsl:call-template name="getCondition">
                  <xsl:with-param name="pText" select="s0:MEA_2[MEA01 = 'SO']/s0:C502_3[C50201 = 'TC']/C50203"/>
                </xsl:call-template>
              </ns0:Attribute03>
            </xsl:if>
            <ns0:TemplateName>
              <xsl:text>AAK_UK</xsl:text>
            </ns0:TemplateName>

            <xsl:if test="count(s0:HYNLoop1/s0:HYN/s0:C212_17[C21202 = 'EN']) &gt; 0">
              <ns0:UnitOfMeasures>
                <ns0:UnitOfMeasure>
                  <ns0:Code>
                    <xsl:value-of select="s0:HAN[s0:C524/C52401 = 'WU']/s0:C218/C21801" />
                  </ns0:Code>
                  <ns0:QtyperUnitofMeasure>1</ns0:QtyperUnitofMeasure>
                  <xsl:if test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'LN']/s0:C174_5/C17402 != ''">
                    <ns0:Length>
                      <xsl:choose>
                        <xsl:when test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'LN']/s0:C174_5/C17401 = 'MMT'">
                          <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'LN']/s0:C174_5/C17402 div 10" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'LN']/s0:C174_5/C17402" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:Length>
                  </xsl:if>
                  <xsl:if test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'WD']/s0:C174_5/C17402 != ''">
                    <ns0:Width>
                      <xsl:choose>
                        <xsl:when test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'WD']/s0:C174_5/C17401 = 'MMT'">
                          <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'WD']/s0:C174_5/C17402 div 10" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'WD']/s0:C174_5/C17402" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:Width>
                  </xsl:if>
                  <xsl:if test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'HT']/s0:C174_5/C17402 != ''">
                    <ns0:Height>
                      <xsl:choose>
                        <xsl:when test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'HT']/s0:C174_5/C17401 = 'MMT'">
                          <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'HT']/s0:C174_5/C17402 div 10" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PD'][s0:C502_8/C50201 = 'HT']/s0:C174_5/C17402" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:Height>
                  </xsl:if>
                  <xsl:if test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'AAE'][s0:C502_8/C50201 = 'AAB']/s0:C174_5/C17402 != ''">
                    <ns0:GrossWeight>
                      <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'AAE'][s0:C502_8/C50201 = 'AAB']/s0:C174_5/C17402" />
                    </ns0:GrossWeight>
                  </xsl:if>
                  <xsl:if test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'AAE'][s0:C502_8/C50201 = 'ADZ']/s0:C174_5/C17402 != ''">
                    <ns0:NetWeight>
                      <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'AAE'][s0:C502_8/C50201 = 'ADZ']/s0:C174_5/C17402" />
                    </ns0:NetWeight>
                  </xsl:if>
                  <ns0:EANCode>
                    <xsl:value-of select="s0:HYNLoop1/s0:HYN/s0:C212_17[C21202 = 'EN']/C21201" />
                  </ns0:EANCode>
                  <ns0:UnitOfMeasureCarriers>
                    <ns0:UnitOfMeasureCarrier>
                      <ns0:CarrierTypeCode>
                        <xsl:value-of select="s0:PACLoop1/s0:PAC[PAC01 = '1']/s0:C202/C20201" />
                      </ns0:CarrierTypeCode>
                      <ns0:QtyperUOMCode>
                        <xsl:value-of select="s0:HYNLoop1/s0:QTY_4/s0:C186_4[C18601 = 'LR']/C18602 * s0:HYNLoop1/s0:QTY_4/s0:C186_4[C18601 = 'URL']/C18602" />
                      </ns0:QtyperUOMCode>
                      <xsl:if test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PL'][s0:C502_8/C50201 = 'HT']/s0:C174_5/C17402 != ''">
                        <ns0:Height>
                          <xsl:choose>
                            <xsl:when test="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PL'][s0:C502_8/C50201 = 'HT']/s0:C174_5/C17401 = 'MMT'">
                              <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PL'][s0:C502_8/C50201 = 'HT']/s0:C174_5/C17402 div 10" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="s0:HYNLoop1/s0:CCILoop3/s0:MEA_5[MEA01 = 'PL'][s0:C502_8/C50201 = 'HT']/s0:C174_5/C17402" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </ns0:Height>
                      </xsl:if>
                    </ns0:UnitOfMeasureCarrier>
                  </ns0:UnitOfMeasureCarriers>
                </ns0:UnitOfMeasure>
              </ns0:UnitOfMeasures>
            </xsl:if>
          </ns0:CustomerItem>
        </xsl:for-each>
      </ns0:CustomerItems>

    </ns0:Message>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public string ParseDate(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }           

		]]>
  </msxsl:script>
</xsl:stylesheet>