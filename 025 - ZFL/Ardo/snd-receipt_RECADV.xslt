<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                exclude-result-prefixes="msxsl var s0"
                version="3.0"  > 
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  
  <xsl:key name="average" match="s0:DocumentLines/s0:DocumentLine/s0:CarrierTypeCode" use="text()"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <xsl:variable name="InBulk" select="s0:Attributes/s0:Attribute[s0:Code = 'ARDO_BULK']/s0:Value"/>
    <ns0:EFACT_D01B_RECADV>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>RECADV</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>01B</UNH2.3>
          <UNH2.4>UN</UNH2.4>
          <UNH2.5>EAN005</UNH2.5>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>632</C00201>
        </ns0:C002>
        <ns0:C106>
          <C10601>
            <xsl:value-of select="s0:ExternalDocumentNo" />
          </C10601>
        </ns0:C106>
        <BGM03>9</BGM03>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="format-date(s0:DocumentDate, '[Y0001][M01][D01]')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>50</C50701>
          <C50702>
            <xsl:value-of select="format-date(s0:PostingDate, '[Y0001][M01][D01]')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>DQ</C50601>
            <C50602>
              <xsl:value-of select="s0:ExternalDocumentNo" />
            </C50602>
          </ns0:C506>
        </ns0:RFF>
      </ns0:RFFLoop1>
      
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="s0:Customer/s0:EANCode" />
            </C08201>
          </ns0:C082>
          <ns0:C080>
            <C08001>
              <xsl:value-of select="upper-case(s0:Customer/s0:Name)" />
            </C08001>
          </ns0:C080>
          <ns0:C059>
            <C05901>
              <xsl:value-of select="upper-case(s0:Customer/s0:Address)" />
            </C05901>
            <C05902>
              <xsl:value-of select="upper-case(s0:Customer/s0:City)" />
            </C05902>
            <C05903>
              <xsl:value-of select="upper-case(s0:Customer/s0:PostCode)" />
            </C05903>
            <C05904>
              <xsl:value-of select="upper-case(s0:Customer/s0:CountryName)" />
            </C05904>
          </ns0:C059>
        </ns0:NAD>
      </ns0:NADLoop1>
      
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>WH</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:text>5430002021003</xsl:text>
            </C08201>
          </ns0:C082>
          <ns0:C080>
            <C08001>
              <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:Name)" /> -->
              <xsl:text>ZEEBRUGGE FOOD LOGISTICS NV</xsl:text>
            </C08001>
          </ns0:C080>
          <ns0:C059>
            <C05901>
              <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:Address)" /> -->
              <xsl:text>IERSE ZEESTRAAT 50</xsl:text>
            </C05901>
            <C05902>
              <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:City)" /> -->
              <xsl:text>ZEEBRUGGE</xsl:text>
            </C05902>
            <C05903>
              <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:PostCode)" /> -->
              <xsl:text>8380</xsl:text>
            </C05903>
            <C05904>
              <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:CountryName)" /> -->
              <xsl:text>BE</xsl:text>
            </C05904>
          </ns0:C059>
        </ns0:NAD>
      </ns0:NADLoop1>
      
      <ns0:CPSLoop1>
        <ns0:CPS>
          <CPS01>
            <xsl:value-of select="position()" />
          </CPS01>
        </ns0:CPS>
        <ns0:PACLoop1>
          <ns0:PAC>
            <PAC01>
              <xsl:value-of select="sum(//s0:CarrierQuantity)" />
            </PAC01>
            <ns0:C531>
              <C53101>
                <!-- select most common carrier type -->
                <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type='1']/s0:CarrierTypeCode[generate-id() = generate-id(key('average',text())[1])]">     
                  <xsl:sort select="count(//s0:DocumentLines/s0:DocumentLine[s0:Type='1']/s0:CarrierTypeCode[text()=current()])"  order="descending"/>
                  <xsl:if test="position()=1">
                    <!-- <xsl:value-of select="current()"/> -->
                    
                    <xsl:choose>
                      <xsl:when test="current() = 'EURO'">
                        <xsl:text>201</xsl:text>
                      </xsl:when>
                      <xsl:when test="current() = 'INDUS'">
                        <xsl:text>202</xsl:text>
                      </xsl:when>
                    </xsl:choose>
                    <!-- " (<xsl:value-of select="count(//s0:DocumentLines/s0:DocumentLine[s0:Type='1']/s0:CarrierTypeCode[text()=current()])"/>) -->
                  </xsl:if>       
                </xsl:for-each>
              </C53101>
            </ns0:C531>
          </ns0:PAC>
        </ns0:PACLoop1>
      </ns0:CPSLoop1>
      
      <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type='1']/s0:DocumentDetailLines/s0:DocumentDetailLine[s0:Posted = '1']">
        <!-- <xsl:for-each select="> -->
        <xsl:variable name="CarrierNo" select="s0:No" />
        <xsl:variable name="LineNo">
          <xsl:value-of select="s0:DocumentLineNo" />
        </xsl:variable>
        <xsl:variable name="AttachedtoLineNo">
          <xsl:value-of select="../../s0:AttachedtoLineNo" />
        </xsl:variable>
        <ns0:CPSLoop1>
          <ns0:CPS>
            <CPS01>
              <xsl:value-of select="position()+1" />
            </CPS01>
            <CPS02>
              <xsl:text>1</xsl:text>
            </CPS02>
          </ns0:CPS>
          <ns0:PACLoop1>
            <ns0:PAC>
              <PAC01>
                <xsl:text>1</xsl:text>
              </PAC01>
              <ns0:C202>
                <C20201>
                  <!-- <xsl:value-of select="s0:CarrierTypeCode" /> -->
                  <xsl:choose>
                    <xsl:when test="s0:CarrierTypeCode = 'EURO'">
                      <xsl:text>201</xsl:text>
                    </xsl:when>
                    <xsl:when test="s0:CarrierTypeCode = 'INDUS'">
                      <xsl:text>202</xsl:text>
                    </xsl:when>
                  </xsl:choose>
                </C20201>
              </ns0:C202>
            </ns0:PAC>
            <ns0:PCILoop1>
              <ns0:PCI>
                <PCI01>33E</PCI01>
              </ns0:PCI>
              <ns0:GINLoop1>
                <ns0:GIN>
                  <GIN01>BJ</GIN01>
                  <ns0:C208_2>
                    <C20801>
                      <xsl:value-of select="s0:CarrierNo" />
                    </C20801>
                  </ns0:C208_2>
                </ns0:GIN>
              </ns0:GINLoop1>
            </ns0:PCILoop1>
          </ns0:PACLoop1>
          <ns0:LINLoop1>
            <ns0:LIN>
              <LIN01>
                <xsl:value-of select="position()"/>
              </LIN01>
              <C212>
                <C21201>
                  <xsl:value-of select="s0:EANCode" />
                </C21201>
                <C21202>EN</C21202>
              </C212>
            </ns0:LIN>
            <ns0:PIA>
              <PIA01>5</PIA01>
              <ns0:C212_2>
                <C21201>
                  <xsl:value-of select="s0:ExternalNo" />
                </C21201>
                <C21202>SA</C21202>
              </ns0:C212_2>
            </ns0:PIA>
            <ns0:PIA>
              <PIA01>1</PIA01>
              <ns0:C212_2>
                <C21201>
                  <!-- <xsl:value-of select="s0:DocumentLineNo" /> -->
                  <!-- <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $LineNo]/s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value" /> -->
                  <xsl:choose>
                    <xsl:when test="$AttachedtoLineNo != ''">
                      <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $AttachedtoLineNo]/s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $LineNo]/s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value" />
                    </xsl:otherwise>
                  </xsl:choose>
                </C21201>
                <C21202>LI</C21202>
              </ns0:C212_2>
            </ns0:PIA>
            <xsl:choose>
              <xsl:when test="$InBulk = 'true'">
                <!-- Bulk orders -->
                 <ns0:QTY>
                  <ns0:C186>
                    <C18601>194</C18601>
                    <C18602>
                      <xsl:value-of select="s0:NetWeight" />
                    </C18602>
                    <C18603>
                      <xsl:text>KGM</xsl:text>
                    </C18603>
                  </ns0:C186>
                </ns0:QTY>
                
                <ns0:QTY>
                  <ns0:C186>
                    <C18601>17E</C18601>
                    <C18602>
                      <xsl:value-of select="sum(s0:Quantity)" />
                    </C18602>
                    <C18603>
                      <xsl:text>PAL</xsl:text>
                    </C18603>
                  </ns0:C186>
                </ns0:QTY>
                
              </xsl:when>
              <xsl:otherwise>
                <!-- Per TU -->
                <ns0:QTY>
                  <ns0:C186>
                    <C18601>194</C18601>
                    <C18602>
                      <xsl:value-of select="sum(s0:Quantity)" />
                    </C18602>
                    <C18603>
                      <xsl:choose>
                        <xsl:when test="substring(s0:UnitofMeasureCode, 1, 3) = 'CRT'">
                          <xsl:text>TU</xsl:text>
                        </xsl:when>
                      </xsl:choose>
                    </C18603>
                  </ns0:C186>
                </ns0:QTY>
                
              </xsl:otherwise>
            </xsl:choose>
            
            <xsl:if test="s0:ExpirationDate != ''">
              <ns0:DTM_5>
                <ns0:C507_5>
                  <C50701>361</C50701>
                  <C50702>
                    <xsl:value-of select="format-date(s0:ExpirationDate, '[Y0001][M01][D01]')" />
                  </C50702>
                  <C50703>102</C50703>
                </ns0:C507_5>
              </ns0:DTM_5>
            </xsl:if>
            <xsl:if test="s0:ExternalBatchNo != ''">
              <ns0:GINLoop2>
                <ns0:GIN_2>
                  <GIN01>BX</GIN01>
                  <ns0:C208_7>
                    <C20801>
                      <xsl:value-of select="s0:ExternalBatchNo" />
                    </C20801>
                  </ns0:C208_7>
                </ns0:GIN_2>
              </ns0:GINLoop2>
            </xsl:if>
            
            <!-- <ns0:RFFLoop3>
                 <ns0:RFF_4>
                 <ns0:C506_4>
                 <C50601>PE</C50601>
                 <C50602>
                 Plant / warehouse location from loc segment DESADV
                 </C50602>
                 </ns0:C506_4>
                 </ns0:RFF_4>
                 </ns0:RFFLoop3> -->
            <!-- <ns0:RFFLoop3>
                 <ns0:RFF_4>
                 <ns0:C506_4>
                 <C50601>WS</C50601>
                 <C50602>
                 WH storage loc from loc segment DESADV
                 </C50602>
                 </ns0:C506_4>
                 </ns0:RFF_4>
                 </ns0:RFFLoop3> -->
             </ns0:LINLoop1>
        </ns0:CPSLoop1>
      </xsl:for-each>
      <!-- </xsl:for-each> -->
    </ns0:EFACT_D01B_RECADV>
  </xsl:template>
</xsl:stylesheet>
