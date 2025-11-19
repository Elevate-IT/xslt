<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <ns0:EFACT_D96A_RECADV>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>RECADV</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>96A</UNH2.3>
          <UNH2.4>UN</UNH2.4>
          <UNH2.5>EAN003</UNH2.5>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>352</C00201>
          <C00203>9</C00203>
        </ns0:C002>
        <BGM02>
          <xsl:value-of select="s0:ExternalDocumentNo" />
        </BGM02>
        <BGM03>9</BGM03>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>50</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(s0:PostingDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>ON</C50601>
            <C50602>
              <xsl:value-of select="s0:ExternalDocumentNo" />
            </C50602>
          </ns0:C506>
        </ns0:RFF>
      </ns0:RFFLoop1>
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>DQ</C50601>
            <C50602>
              <xsl:value-of select="s0:No" />
            </C50602>
          </ns0:C506>
        </ns0:RFF>
      </ns0:RFFLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:Header/s0:ToTradingPartner" />
            </C08201>
            <C08202>9</C08202>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>WH</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:Header/s0:FromTradingPartner" />
            </C08201>
            <C08202>9</C08202>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>

      <!--<ns0:TODLoop1>
        <ns0:TOD>
          <TOD01>2</TOD01>
          <ns0:C100>
            <C10004>
              <xsl:value-of select="'PLACEHOLDER'" />
            </C10004>
          </ns0:C100>
        </ns0:TOD>
      </ns0:TODLoop1>-->

      <ns0:CPSLoop1>
        <ns0:CPS>
          <CPS01>
            <xsl:value-of select="MyScript:GetCPSCounter()" />
          </CPS01>
        </ns0:CPS>
        <ns0:PACLoop1>
          <ns0:PAC>
            <PAC01>
              <xsl:value-of select="s0:CarrierQuantity" />
            </PAC01>
          </ns0:PAC>
        </ns0:PACLoop1>
      </ns0:CPSLoop1>

      <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type='1']">
        <xsl:for-each select="s0:DocumentDetailLines/s0:DocumentDetailLine[s0:Posted = '1']">
          <xsl:variable name="CarrierNo">
            <xsl:value-of select="s0:CarrierNo" />
          </xsl:variable>
          <ns0:CPSLoop1>
            <ns0:CPS>
              <CPS01>
                <xsl:value-of select="MyScript:GetCPSCounter()" />
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
                    <xsl:value-of select="s0:CarrierTypeCode" />
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
                    <ns0:C208>
                      <C20801>
                        <xsl:value-of select="s0:CarrierNo" />
                      </C20801>
                    </ns0:C208>
                  </ns0:GIN>
                </ns0:GINLoop1>
              </ns0:PCILoop1>
            </ns0:PACLoop1>
            <ns0:LINLoop1>
              <ns0:LIN>
                <LIN01>
                  <xsl:value-of select="MyScript:GetLinCounter()" />
                </LIN01>
                <ns0:C212>
                  <C21201>
                    <xsl:value-of select="s0:EANCode" />
                  </C21201>
                  <C21202>EN</C21202>
                </ns0:C212>
              </ns0:LIN>
              <ns0:PIA>
                <PIA01>1</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="s0:ExternalNo" />
                  </C21201>
                  <C21202>SA</C21202>
                </ns0:C212_2>
              </ns0:PIA>
              <!--<ns0:PIA>
                <PIA01>1</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="s0:DocumentLineNo" />
                  </C21201>
                  <C21202>LI</C21202>
                </ns0:C212_2>
              </ns0:PIA>-->
              <ns0:QTY>
                <ns0:C186>
                  <C18601>194</C18601>
                  <C18602>
                    <xsl:value-of select="s0:Quantity" />
                  </C18602>
                  <C18603>
                    <xsl:value-of select="substring(s0:UnitofMeasureCode, 1, 3)" />
                  </C18603>
                </ns0:C186>
              </ns0:QTY>
              <xsl:if test="s0:ExpirationDate != ''">
                <ns0:DTM_5>
                  <ns0:C507_5>
                    <C50701>361</C50701>
                    <C50702>
                      <xsl:value-of select="MyScript:ParseDate(s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
                    </C50702>
                    <C50703>102</C50703>
                  </ns0:C507_5>
                </ns0:DTM_5>
              </xsl:if>
              <xsl:if test="s0:ExternalBatchNo != ''">
                <ns0:GINLoop2>
                  <ns0:GIN_2>
                    <GIN01>BX</GIN01>
                    <ns0:C208_6>
                      <C20801>
                        <xsl:value-of select="s0:ExternalBatchNo" />
                      </C20801>
                    </ns0:C208_6>
                  </ns0:GIN_2>
                </ns0:GINLoop2>
              </xsl:if>
            </ns0:LINLoop1>
          </ns0:CPSLoop1>
        </xsl:for-each>

        <!--<xsl:if test="count(s0:DocumentDetailLines/s0:DocumentDetailLine) = 0">
          <ns0:CPSLoop1>
            <ns0:CPS>
              <CPS01>
                <xsl:value-of select="position()" />
              </CPS01>
            </ns0:CPS>
            <ns0:LINLoop1>
              <ns0:LIN>
                <LIN01>
                  <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'SAPLINENO']/s0:Value" />
                </LIN01>
                <ns0:C212>
                  <C21201>
                    <xsl:value-of select="s0:EANCode" />
                  </C21201>
                  <C21202>EN</C21202>
                </ns0:C212>
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
              <ns0:QTY>
                <ns0:C186>
                  <C18601>
                    <xsl:value-of select="48"/>
                  </C18601>
                  <C18602>
                    <xsl:value-of select="0"/>
                  </C18602>
                  <C18603>CT</C18603>
                </ns0:C186>
              </ns0:QTY>
              <ns0:GINLoop2>
                <ns0:GIN_2>
                  <GIN01>BX</GIN01>
                  <ns0:C208_6>
                    <C20801>DUMMY</C20801>
                  </ns0:C208_6>
                </ns0:GIN_2>
                <ns0:CDILoop9>
                  <ns0:CDI_12>
                    <CDI01>1</CDI01>
                    <ns0:C564_12>
                      <C56401>
                        <xsl:choose>
                          <xsl:when test="s0:InitialCarrierStatusCode = '90-BLOQUE'">7</xsl:when>
                          <xsl:when test="s0:InitialCarrierStatusCode = '50-COOL DOWN'">5</xsl:when>
                          <xsl:when test="s0:InitialCarrierStatusCode = '51-CUSTOMER RETURN'">5</xsl:when>
                          <xsl:when test="s0:InitialCarrierStatusCode = '52-QI EXPORT'">5</xsl:when>
                          <xsl:otherwise>9</xsl:otherwise>
                        </xsl:choose>
                      </C56401>
                    </ns0:C564_12>
                  </ns0:CDI_12>
                </ns0:CDILoop9>
              </ns0:GINLoop2>
            </ns0:LINLoop1>
          </ns0:CPSLoop1>
        </xsl:if>-->
      </xsl:for-each>
    </ns0:EFACT_D96A_RECADV>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      int CPSCounter = 0;
      public string GetCPSCounter()
      {
        return (++CPSCounter).ToString();
      }
      
      public int NRCounter2 = 1;
      public string GetNRCounter2(bool increment)
      {
        if (increment)
          NRCounter2 += 1;
        return (NRCounter2).ToString();
      }
      
      public string GetNRCounter3()
      {
        return (NRCounter2 - 1).ToString();
      }
            
      public int NRCounter = 0;
      public string GetNRCounter(bool increment)
      {
        if (increment){
          NRCounter2 = 1;
          NRCounter += 1;
        }        
        return (NRCounter).ToString();
      }
      
      public int LINCounter = 0;
      public string GetLinCounter()
      {
          LINCounter = LINCounter + 1;
          return LINCounter.ToString();
      }   
      
			public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseDate(string input, string formatIn, string formatOut)

      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }
      
    public int QtyOnCarrier {get;set;}
    public void AddToQtyOnCarrier(int qtyOnCarrier)
	  {       
       QtyOnCarrier = QtyOnCarrier + qtyOnCarrier;             
    }
    
    public void SetQtyOnCarrier(int qtyOnCarrier)
	  {       
       QtyOnCarrier = qtyOnCarrier;             
    }
    
    public int GetQtyOnCarrier()
	  {       
       return QtyOnCarrier;             
    }
             
    public int QtyOnCarrierRetour {get;set;}
    public void AddToQtyOnCarrierRetour(int qtyOnCarrierRetour)
	  {       
       QtyOnCarrierRetour = QtyOnCarrierRetour + qtyOnCarrierRetour;             
    }
    
    public void SetQtyOnCarrierRetour(int qtyOnCarrierRetour)
	  {       
       QtyOnCarrierRetour = qtyOnCarrierRetour;             
    }
    
    public int GetQtyOnCarrierRetour()
	  {       
       return QtyOnCarrierRetour;             
    }
      
		]]>
  </msxsl:script>
</xsl:stylesheet>