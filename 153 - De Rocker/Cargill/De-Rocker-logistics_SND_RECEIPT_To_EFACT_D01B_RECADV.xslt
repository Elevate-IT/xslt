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
          <UNH2.5>EAN007</UNH2.5>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>632</C00201>
          <C00204>
            <xsl:choose>
              <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'CG_ORDRTYP']/s0:Value = 'PO'">
                <xsl:text>O4</xsl:text>
              </xsl:when>
              <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'CG_ORDRTYP']/s0:Value = 'transfer'">
                <xsl:text>OH</xsl:text>
              </xsl:when>
            </xsl:choose>
          </C00204>
        </ns0:C002>
        <ns0:C106>
          <C10601>
            <xsl:value-of select="s0:ExternalDocumentNo" />
          </C10601>
        </ns0:C106>
        <BGM03>29</BGM03>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:CreationDateTime, 's', 'yyyyMMddHHmm')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>50</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:PostingDate, 'yyyy-MM-dd', 'yyyyMMddHHmm')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:FTX>
        <FTX01>TRA</FTX01>
        <ns0:C108>
          <C10801>TRUCK NUMBER</C10801>
          <C10802>DUMMYTRUCK</C10802>
        </ns0:C108>
      </ns0:FTX>
      <ns0:FTX>
        <FTX01>TRA</FTX01>
        <ns0:C108>
          <C10801>TRAILER NUMBER</C10801>
          <C10802>DUMMYTRAILER</C10802>
        </ns0:C108>
      </ns0:FTX>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="s0:Customer/s0:No2" />
            </C08201>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>DGC</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'CG_ADDRESS']/s0:Value" />
            </C08201>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>

      <ns0:CPSLoop1>
        <ns0:CPS>
          <CPS01>
            <xsl:value-of select="position()" />
          </CPS01>
        </ns0:CPS>

        <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type='1'][s0:QtyPosted &gt; 0]">
          <ns0:LINLoop1>
            <ns0:LIN>
              <LIN01>
                <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value" />
              </LIN01>
              <ns0:C212>
                <C21201>
                  <xsl:value-of select="s0:ExternalNo" />
                </C21201>
                <C21202>SA</C21202>
              </ns0:C212>
            </ns0:LIN>
            <xsl:if test="s0:ExternalBatchNo != ''">
              <ns0:PIA>
                <PIA01>1</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="s0:ExternalBatchNo" />
                  </C21201>
                  <C21202>BB</C21202>
                </ns0:C212_2>
              </ns0:PIA>
            </xsl:if>
            <ns0:IMD>
              <IMD01>F</IMD01>
              <ns0:C272>
                <C27201>DSC</C27201>
              </ns0:C272>
              <ns0:C273>
                <C27304>
                  <xsl:value-of select="s0:Description" />
                </C27304>
                <C27306>EN</C27306>
              </ns0:C273>
            </ns0:IMD>
            <ns0:QTY>
              <ns0:C186>
                <C18601>
                  <xsl:value-of select="1"/>
                </C18601>
                <C18602>
                  <xsl:choose>
                    <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'CG_UOM']/s0:Value = 'TNE'">
                      <xsl:value-of select="format-number(s0:PostedOrderQuantity div 1000, '0.###')" />
                    </xsl:when>
                    <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'CG_UOM']/s0:Value = 'MT'">
                      <xsl:value-of select="format-number(s0:PostedOrderQuantity div 1000, '0.###')" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(s0:PostedOrderQuantity, '0.###')" />
                    </xsl:otherwise>
                  </xsl:choose>
                </C18602>
                <C18603>
                  <xsl:choose>
                    <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'CG_UOM']/s0:Value != ''">
                      <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'CG_UOM']/s0:Value" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(s0:OrderUnitofMeasureCode, 1, 3)" />
                    </xsl:otherwise>
                  </xsl:choose>
                </C18603>
              </ns0:C186>
            </ns0:QTY>
          </ns0:LINLoop1>
        </xsl:for-each>
      </ns0:CPSLoop1>
    </ns0:EFACT_D01B_RECADV>
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