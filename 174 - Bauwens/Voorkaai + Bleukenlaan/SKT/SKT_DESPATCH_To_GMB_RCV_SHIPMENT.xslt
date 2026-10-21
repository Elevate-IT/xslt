<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="msxsl var xs" version="3.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00">
  
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes" />
  
  <xsl:template match="/">
    <xsl:apply-templates select="DESPATCH" />
  </xsl:template>

  <xsl:template match="DESPATCH">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/MessageId" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="current-dateTime()" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="UNH/Sender" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="UNH/Receiver" />
        </ns0:ToTradingPartner>
      </ns0:Header>

      <ns0:Documents>
        <xsl:for-each select="DELIVERY">
          <xsl:variable name="FirstLoadCarRunSeq">
            <xsl:value-of select="(DespatchData/FirstLoadCarRunSeq)[1]" />
          </xsl:variable>
          <ns0:Document>
            <ns0:BuildingCode>
              <xsl:choose>
                <xsl:when test="DespatchData[CarrierRunSeqId = $FirstLoadCarRunSeq]/PickingInstructions = '100'">
                  <xsl:text>TURNHOUT 1</xsl:text>
                </xsl:when>
                <xsl:when test="DespatchData[CarrierRunSeqId = $FirstLoadCarRunSeq]/PickingInstructions = '900'">
                  <xsl:text>BL</xsl:text>
                </xsl:when>
                <xsl:when test="DespatchData[CarrierRunSeqId = $FirstLoadCarRunSeq]/PickingInstructions = '1993'">
                  <xsl:text>VOORKAAI</xsl:text>
                </xsl:when>
              </xsl:choose>
            </ns0:BuildingCode>
            <ns0:DocumentDate>
              <xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]')"/>
            </ns0:DocumentDate>
            <ns0:PostingDate>
              <xsl:value-of select="let $d := string((DespatchData/CarrierRunDate)[1]) return if ($d = '') then '' else format-date(xs:date(replace($d, '^(\d{4})(\d{2})(\d{2})$', '$1-$2-$3')), '[Y0001]-[M01]-[D01]')"/>
            </ns0:PostingDate>
            <ns0:ExternalDocumentNo>
              <xsl:value-of select="concat((DespatchData/CarrierRunId)[1], '-', (CallOffData/DeliveryAddressId)[1])" />
            </ns0:ExternalDocumentNo>
            
            <ns0:ShippingAgent>
              <ns0:ExternalNo>
                <xsl:value-of select="(DespatchData/CarrierAddressId)[1]" />
              </ns0:ExternalNo>
              <ns0:Name>
                <xsl:value-of select="(DespatchData/CarrierName)[1]" />
              </ns0:Name>
              <ns0:Address>
                <xsl:value-of select="(DespatchData/CarrierName2)[1]" />
              </ns0:Address>
              <ns0:Address2>
                <xsl:value-of select="(DespatchData/CarrierAddress)[1]" />
              </ns0:Address2>
              <ns0:City>
                <xsl:value-of select="(DespatchData/CarrierCity)[1]" />
              </ns0:City>
              <ns0:PostCode>
                <xsl:value-of select="(DespatchData/CarrierZip)[1]" />
              </ns0:PostCode>
              <ns0:CountryCode>
                <xsl:value-of select="(DespatchData/CarrierCountryId)[1]" />
              </ns0:CountryCode>
            </ns0:ShippingAgent>
            
            <ns0:OrderTypeCode>
              <xsl:text>SMURFITKAPPA</xsl:text>
            </ns0:OrderTypeCode>
            
            <ns0:ShipToAddress>
              <!--<ns0:ExternalNo>
                   <xsl:value-of select="(CallOffData/DeliveryAddressId)[1]" />
                   </ns0:ExternalNo>-->
              <ns0:Name>
                <xsl:value-of select="(CallOffData/DeliveryName)[1]" />
              </ns0:Name>
              <ns0:Address>
                <xsl:value-of select="(CallOffData/DeliveryName2)[1]" />
              </ns0:Address>
              <ns0:Address2>
                <xsl:value-of select="(CallOffData/DeliveryAddress)[1]" />
              </ns0:Address2>
              <ns0:City>
                <xsl:value-of select="(CallOffData/DeliveryCity)[1]" />
              </ns0:City>
              <ns0:PostCode>
                <xsl:value-of select="(CallOffData/DeliveryZip)[1]" />
              </ns0:PostCode>
              <ns0:CountryCode>
                <xsl:value-of select="(CallOffData/DeliveryCountryId)[1]" />
              </ns0:CountryCode>
            </ns0:ShipToAddress>
            
            <ns0:TripNo>
              <xsl:value-of select="(DespatchData/CarrierRunId)[1]" />
            </ns0:TripNo>
            <ns0:SequenceNo>
              <xsl:value-of select="(DespatchData/LoadSeq)[1]" />
            </ns0:SequenceNo>
            
            <ns0:Attributes>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_CUSTID</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerId)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_NAME</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerName)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_NAM2</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerName2)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_ADDR</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerAddress)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_ZIP</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerZip)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_CITY</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerCity)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_CID</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerCountryId)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_VAT</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerVATNr)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_PHONE</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerPhone)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_FAX</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CustomerFax)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_CRRUNDT</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//CarrierRunDate)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_INCTERM</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//IncoTerms)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_PLR1</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//PackingListRemark1)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_PLR2</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(//PackingListRemark2)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_CARRID</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="(DespatchData/CarrierRunId)[1]"/>
                </ns0:Value>
              </ns0:Attribute>
            </ns0:Attributes>
            
            <ns0:DocumentLines>
              <xsl:for-each select="DespatchData/PalletsDespatch" >
                <xsl:variable name="PalletsDespatch" select="." />
                <xsl:variable name="DeliveryLineID" select="../DeliveryLineId" />
                
                <xsl:for-each select="../../CallOffData[DeliveryLineId = $DeliveryLineID]">
                  <ns0:DocumentLine>
                    <ns0:No>
                      <xsl:value-of select="OrderId" />
                    </ns0:No>
                    <ns0:OrderUnitofMeasureCode>
                      <xsl:value-of select="StockType" />
                    </ns0:OrderUnitofMeasureCode>
                    <ns0:OrderQuantity>
                      <xsl:value-of select="format-number(number($PalletsDespatch/NumberOfPiecesPerPallet) * number($PalletsDespatch/NumberOfPallets), '0.##########')" />
                    </ns0:OrderQuantity>
                    <ns0:QtyPerCarrier>
                      <xsl:value-of select="$PalletsDespatch/NumberOfPiecesPerPallet" />
                    </ns0:QtyPerCarrier>
                    <ns0:BuildingCode>
                      <xsl:choose>
                        <xsl:when test="../DespatchData[DeliveryLineId = $DeliveryLineID]/PickingInstructions = '100'">
                          <xsl:text>TURNHOUT 1</xsl:text>
                        </xsl:when>
                        <xsl:when test="../DespatchData[DeliveryLineId = $DeliveryLineID]/PickingInstructions = '900'">
                          <xsl:text>BL</xsl:text>
                        </xsl:when>
                        <xsl:when test="../DespatchData[DeliveryLineId = $DeliveryLineID]/PickingInstructions = '1993'">
                          <xsl:text>VOORKAAI</xsl:text>
                        </xsl:when>
                      </xsl:choose>
                    </ns0:BuildingCode>
                    <ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_CALLOFF</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="CallOffId" />
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_CUSTAID</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="CustomerItemCode"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_C_ORDRE</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="CustomerOrderReference"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_CODESCR</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="CustomerCallOffDescription"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_FSC_YN</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="CustomerItemFSCYesNo"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_FSC_T</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="CustomerItemFSCText"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_CR_SEQ</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="(../DespatchData[DeliveryLineId = $DeliveryLineID]/CarrierRunSeqId)[1]"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_LR1</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="(../DespatchData[DeliveryLineId = $DeliveryLineID]/LineRemark1)[1]"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_LR2</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="(../DespatchData[DeliveryLineId = $DeliveryLineID]/LineRemark2)[1]"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_PA_GRND</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="(../DespatchData[DeliveryLineId = $DeliveryLineID]/PalletsPerCombination[PalletType = 'G'][1]/PalletAgreement)[1]"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_PA_TOP</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="(../DespatchData[DeliveryLineId = $DeliveryLineID]/PalletsPerCombination[PalletType = 'T'][1]/PalletAgreement)[1]"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_PA_GRD2</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="(../DespatchData[DeliveryLineId = $DeliveryLineID]/PalletsPerCombination[PalletType = 'G'][2]/PalletAgreement)[1]"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_PA_TOP2</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="(../DespatchData[DeliveryLineId = $DeliveryLineID]/PalletsPerCombination[PalletType = 'T'][2]/PalletAgreement)[1]"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_THEORST</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="TheoreticalStock"/>
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>SK_PCSPPAL</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="$PalletsDespatch/NumberOfPiecesPerPallet" />
                        </ns0:Value>
                      </ns0:Attribute>
                    </ns0:Attributes>
                  </ns0:DocumentLine>
                </xsl:for-each>
              </xsl:for-each>
            </ns0:DocumentLines>
            
          </ns0:Document>
        </xsl:for-each>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
</xsl:stylesheet>