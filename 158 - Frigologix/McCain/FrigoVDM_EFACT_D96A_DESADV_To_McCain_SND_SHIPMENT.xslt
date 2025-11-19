<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Group-by-PackageNo" match="//s0:Packages/s0:Package" use="s0:No" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="text()" name="splitSeal">
    <xsl:param name="pText" select="."/>
    <xsl:if test="string-length($pText)">
      <ns0:SEL>
        <SEL01>
          <xsl:value-of select="substring-before(concat($pText,'/'),'/')"/>
        </SEL01>
        <ns0:C215>
          <C21501>SH</C21501>
        </ns0:C215>
      </ns0:SEL>
      <xsl:call-template name="splitSeal">
        <xsl:with-param name="pText" select="substring-after($pText, '/')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <xsl:variable name="Counter" select="position()"></xsl:variable>
    <ns0:EFACT_D96A_DESADV>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>DESADV</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>96A</UNH2.3>
          <UNH2.4>UN</UNH2.4>
          <UNH2.5>EAN005</UNH2.5>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>351</C00201>
          <C00203>9</C00203>
        </ns0:C002>
        <BGM02>
          <xsl:value-of select="s0:ExternalDocumentNo" />
        </BGM02>
        <BGM03>9</BGM03>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>11</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(s0:PostingDate, 'yyyy-MM-dd', 'yyyyMMddHHmm')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:CreationDateTime, 's', 'yyyyMMddHHmm')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>ON</C50601>
            <C50602>
              <xsl:value-of select="s0:ExternalReference" />
            </C50602>
          </ns0:C506>
        </ns0:RFF>
      </ns0:RFFLoop1>
      <xsl:if test="s0:Attributes/s0:Attribute[s0:Code = 'TEMPL']/s0:Value != ''">
        <ns0:RFFLoop1>
          <ns0:RFF>
            <ns0:C506>
              <C50601>IL</C50601>
              <C50602>
                <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'TEMPL']/s0:Value" />
              </C50602>
            </ns0:C506>
          </ns0:RFF>
        </ns0:RFFLoop1>
      </xsl:if>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>DP</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="s0:ShipToAddress/s0:ExternalNo" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SF</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:FromTradingPartner" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:ToTradingPartner" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>
      <xsl:for-each select="//s0:Package[count(. | key('Group-by-PackageNo', s0:No)[1]) = 1]">
        <xsl:variable name="LineKey" select="s0:No" />
        <xsl:if test="s0:No != ''">
          <xsl:value-of select="MyScript:ResetPackageQty()" />
          <xsl:for-each select="//s0:Packages/s0:Package[s0:No = $LineKey]">
            <xsl:value-of select="MyScript:SetPackageQty(s0:Quantity)" />
          </xsl:for-each>
          <ns0:TODLoop1>
            <ns0:TOD>
              <TOD01>2</TOD01>
              <ns0:C100>
                <C10004>
                  <xsl:value-of select="MyScript:GetPalletExchange(s0:No)" />
                </C10004>
              </ns0:C100>
            </ns0:TOD>
          </ns0:TODLoop1>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="s0:Attributes/s0:Attribute[s0:Code = 'SHIPAGENT']/s0:Value != ''">
        <ns0:TDTLoop1>
          <ns0:TDT>
            <TDT01>20</TDT01>
            <ns0:C220>
              <C22001>30</C22001>
            </ns0:C220>
            <ns0:C228>
              <C22801>31</C22801>
            </ns0:C228>
            <ns0:C040>
              <C04001>
                <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'SHIPAGENT']/s0:Value" />
              </C04001>
            </ns0:C040>
            <xsl:choose>
              <xsl:when test="s0:ContainerNo != ''">
                <ns0:C222>
                  <C22204>
                    <xsl:value-of select="s0:ContainerNo" />
                  </C22204>
                </ns0:C222>
              </xsl:when>
              <xsl:when test="s0:VehicleNo != ''">
                <ns0:C222>
                  <C22204>
                    <xsl:value-of select="s0:VehicleNo" />
                  </C22204>
                </ns0:C222>
              </xsl:when>
            </xsl:choose>
          </ns0:TDT>
        </ns0:TDTLoop1>
      </xsl:if>
      <ns0:EQDLoop1>
        <ns0:EQD>
          <EQD01>TE</EQD01>
        </ns0:EQD>
        <xsl:call-template name="splitSeal">
          <xsl:with-param name="pText" select="translate(s0:SealNo, translate(s0:SealNo, '0123456789/', ''), '')"/>
        </xsl:call-template>
      </ns0:EQDLoop1>

      <ns0:CPSLoop1>
        <ns0:CPS>
          <CPS01>
            <xsl:value-of select="MyScript:GetCPSCounter()" />
          </CPS01>
        </ns0:CPS>
        <ns0:PACLoop1>
          <ns0:PAC>
            <PAC01>
              <xsl:value-of select="s0:CarrierQuantity"/>
            </PAC01>
            <ns0:C202>
              <C20201>201</C20201>
              <C20203>9</C20203>
            </ns0:C202>
          </ns0:PAC>
          <ns0:MEA_3>
            <MEA01>PD</MEA01>
            <ns0:C502_3>
              <C50201>AAD</C50201>
            </ns0:C502_3>
            <ns0:C174_3>
              <C17401>KGM</C17401>
              <C17402>
                <xsl:value-of select="format-number(s0:GrossWeight,'#.###')" />
              </C17402>
            </ns0:C174_3>
          </ns0:MEA_3>
        </ns0:PACLoop1>
      </ns0:CPSLoop1>

      <xsl:for-each select="//s0:Carriers/s0:Carrier/s0:Contents/s0:Content">
        <xsl:variable name="DocLineNo" select="s0:DocumentLineNo"></xsl:variable>
        <ns0:CPSLoop1>
          <ns0:CPS>
            <CPS01>
              <xsl:value-of select="MyScript:GetCPSCounter()" />
            </CPS01>
            <CPS02>1</CPS02>
          </ns0:CPS>
          <ns0:PACLoop1>
            <ns0:PAC>
              <PAC01>1</PAC01>
              <ns0:C202>
                <C20201>201</C20201>
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
                      <xsl:value-of select="substring(s0:CarrierNo, 1, 18)"/>
                    </C20801>
                  </ns0:C208>
                </ns0:GIN>
              </ns0:GINLoop1>
            </ns0:PCILoop1>
          </ns0:PACLoop1>
          <ns0:LINLoop1>
            <ns0:LIN>
              <LIN01>
                <xsl:choose>
                  <xsl:when test="//s0:DocumentLines/s0:DocumentLine[s0:LineNo = $DocLineNo]/s0:Attributes/s0:Attribute[s0:Code = 'SAPLINENO']/s0:Value != ''">
                    <xsl:value-of select="//s0:DocumentLines/s0:DocumentLine[s0:LineNo = $DocLineNo]/s0:Attributes/s0:Attribute[s0:Code = 'SAPLINENO']/s0:Value"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="s0:DocumentLineNo"/>
                  </xsl:otherwise>
                </xsl:choose>
              </LIN01>
              <ns0:C212>
                <C21201>
                  <xsl:value-of select="s0:EANCode"/>
                </C21201>
                <C21202>EN</C21202>
              </ns0:C212>
            </ns0:LIN>
            <ns0:PIA>
              <PIA01>5</PIA01>
              <ns0:C212_2>
                <C21201>
                  <xsl:value-of select="s0:ExternalNo"/>
                </C21201>
                <C21202>SA</C21202>
              </ns0:C212_2>
            </ns0:PIA>
            <ns0:QTY_2>
              <ns0:C186_2>
                <C18601>12</C18601>
                <C18602>
                  <xsl:value-of select="s0:Quantity"/>
                </C18602>
                <C18603>CT</C18603>
              </ns0:C186_2>
            </ns0:QTY_2>
            <ns0:FTX_5>
              <FTX01>ZZZ</FTX01>
              <xsl:choose>
                <xsl:when test="../../s0:StatusCode = '50-COOL DOWN'">
                  <FTX02>X</FTX02>
                </xsl:when>
                <xsl:when test="../../s0:StatusCode = '51-CUSTOMER RETURN'">
                  <FTX02>X</FTX02>
                </xsl:when>
                <xsl:when test="../../s0:StatusCode = '52-QI EXPORT'">
                  <FTX02>X</FTX02>
                </xsl:when>
                <xsl:otherwise>UNRESTRICTED</xsl:otherwise>
              </xsl:choose>
              <ns0:C108_5>
                <C10801>
                  <xsl:choose>
                    <xsl:when test="../../s0:StatusCode = '90-BLOQUE'">BLOCKED</xsl:when>
                    <xsl:when test="../../s0:StatusCode = '50-COOL DOWN'">QI</xsl:when>
                    <xsl:when test="../../s0:StatusCode = '51-CUSTOMER RETURN'">QI</xsl:when>
                    <xsl:when test="../../s0:StatusCode = '52-QI EXPORT'">QI</xsl:when>
                    <xsl:otherwise>UNRESTRICTED</xsl:otherwise>
                  </xsl:choose>
                </C10801>
              </ns0:C108_5>
            </ns0:FTX_5>
            <ns0:PCILoop2>
              <ns0:PCI_2>
                <PCI01>36E</PCI01>
              </ns0:PCI_2>
              <ns0:DTM_9>
                <ns0:C507_9>
                  <C50701>94</C50701>
                  <C50702>
                    <xsl:value-of select="MyScript:ParseDate(s0:ProductionDate, 'yyyy-MM-dd', 'yyyyMMdd')"/>
                  </C50702>
                  <C50703>102</C50703>
                </ns0:C507_9>
              </ns0:DTM_9>
              <ns0:DTM_9>
                <ns0:C507_9>
                  <C50701>361</C50701>
                  <C50702>
                    <xsl:value-of select="MyScript:ParseDate(s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')"/>
                  </C50702>
                  <C50703>102</C50703>
                </ns0:C507_9>
              </ns0:DTM_9>
              <ns0:GINLoop2>
                <ns0:GIN_3>
                  <GIN01>BX</GIN01>
                  <ns0:C208_11>
                    <C20801>
                      <xsl:value-of select="s0:ExternalBatchNo"/>
                    </C20801>
                  </ns0:C208_11>
                </ns0:GIN_3>
              </ns0:GINLoop2>
            </ns0:PCILoop2>
          </ns0:LINLoop1>
        </ns0:CPSLoop1>
      </xsl:for-each>

      <xsl:for-each select="//s0:DocumentLine[s0:Type=1][string-length(s0:QtyPosted)=0]">
        <ns0:CPSLoop1>
          <ns0:CPS>
            <CPS01>
              <xsl:value-of select="MyScript:GetCPSCounter()" />
            </CPS01>
            <CPS02>1</CPS02>
          </ns0:CPS>
          <ns0:PACLoop1>
            <ns0:PAC>
              <PAC01>1</PAC01>
              <ns0:C202>
                <C20201>201</C20201>
              </ns0:C202>
            </ns0:PAC>
            <ns0:PCILoop1>
              <ns0:PCI>
                <PCI01>33E</PCI01>
              </ns0:PCI>
              <!--<ns0:GINLoop1>
                <ns0:GIN>
                  <GIN01>BJ</GIN01>
                  <ns0:C208>
                    <C20801>
                      <xsl:value-of select="substring(s0:CarrierNo, 1, 18)"/>
                    </C20801>
                  </ns0:C208>
                </ns0:GIN>
              </ns0:GINLoop1>-->
            </ns0:PCILoop1>
          </ns0:PACLoop1>
          <ns0:LINLoop1>
            <ns0:LIN>
              <LIN01>
                <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'SAPLINENO']/s0:Value"/>
              </LIN01>
              <ns0:C212>
                <C21201>
                  <xsl:value-of select="s0:EANCode"/>
                </C21201>
                <C21202>EN</C21202>
              </ns0:C212>
            </ns0:LIN>
            <ns0:PIA>
              <PIA01>5</PIA01>
              <ns0:C212_2>
                <C21201>
                  <xsl:value-of select="s0:ExternalNo"/>
                </C21201>
                <C21202>SA</C21202>
              </ns0:C212_2>
            </ns0:PIA>
            <ns0:QTY_2>
              <ns0:C186_2>
                <C18601>12</C18601>
                <C18602>0</C18602>
                <C18603>CT</C18603>
              </ns0:C186_2>
            </ns0:QTY_2>
            <!--<ns0:FTX_5>
              <FTX01>ZZZ</FTX01>
              <ns0:C108_5>
                <C10801>
                  <xsl:choose>
                    <xsl:when test="../../s0:StatusCode = '90-BLOQUE'">Blocked</xsl:when>
                    <xsl:when test="../../s0:StatusCode = '50-QUARANTAINE'">QI</xsl:when>
                    <xsl:otherwise>Unrestricted</xsl:otherwise>
                  </xsl:choose>
                </C10801>
              </ns0:C108_5>
            </ns0:FTX_5>-->
            <ns0:PCILoop2>
              <ns0:PCI_2>
                <PCI01>36E</PCI01>
              </ns0:PCI_2>
              <!--<ns0:DTM_9>
                <ns0:C507_9>
                  <C50701>94</C50701>
                  <C50702>
                    <xsl:value-of select="MyScript:ParseDate(s0:ProductionDate, 'yyyy-MM-dd', 'yyyyMMdd')"/>
                  </C50702>
                  <C50703>102</C50703>
                </ns0:C507_9>
              </ns0:DTM_9>
              <ns0:DTM_9>
                <ns0:C507_9>
                  <C50701>361</C50701>
                  <C50702>
                    <xsl:value-of select="MyScript:ParseDate(s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')"/>
                  </C50702>
                  <C50703>102</C50703>
                </ns0:C507_9>
              </ns0:DTM_9>-->
              <!--<ns0:GINLoop2>
                <ns0:GIN_3>
                  <GIN01>BX</GIN01>
                  <ns0:C208_11>
                    <C20801>
                      <xsl:value-of select="s0:ExternalBatchNo"/>
                    </C20801>
                  </ns0:C208_11>
                </ns0:GIN_3>
              </ns0:GINLoop2>-->
            </ns0:PCILoop2>
          </ns0:LINLoop1>
        </ns0:CPSLoop1>
      </xsl:for-each>

    </ns0:EFACT_D96A_DESADV>
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
        else {
          NRCounter2 = 1;
          NRCounter3 = NRCounter;
        }
          
        return (NRCounter2).ToString();
      }
      
      public int NRCounter3;
      public string GetNRCounter3(bool increment)
      {
        if (increment){
          NRCounter3 = NRCounter - 1;
        }
          
        return (NRCounter3).ToString();
      }
            
      public int NRCounter = 0;
      public string GetNRCounter(bool increment)
      {
        if (increment){
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
      
			public string ToUpper(string input)
			{
				return input.ToUpper();
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
    
    public string TrimEnd(string input)
    {
       return input.TrimEnd();
    }
    
    public string RemoveDiacritics(string text)
	  {
		  var normalizedString = text.Normalize(System.Text.NormalizationForm.FormD);
		  var stringBuilder = new System.Text.StringBuilder();
		  foreach (var c in normalizedString)
		  {
			  var unicodeCategory = System.Globalization.CharUnicodeInfo.GetUnicodeCategory(c);
			  if (unicodeCategory != System.Globalization.UnicodeCategory.NonSpacingMark)
			  {
				  stringBuilder.Append(c);
			  }
		  }

		  return stringBuilder.ToString().Normalize(System.Text.NormalizationForm.FormC);
	  }
    
    int PackageInQty = 0;
    int PackageOutQty = 0;
    public void SetPackageQty(int qty) {
      if (qty < 0) {
        PackageInQty += qty;
      } else {
        PackageOutQty += qty;
      }
    }
    
    public int GetPackageQty(string direction) {
      switch (direction.ToUpper())
        {
          case "IN":
          return Math.Abs(PackageInQty);
          
          case "OUT":
          return Math.Abs(PackageOutQty);
          
          default:
          return 0;
        }
    }
    
    public void ResetPackageQty() {
      PackageInQty = 0;
      PackageOutQty = 0;
    }
    
    public string GetPalletExchange(string packageType) {
      string type;
      switch (packageType.ToUpper())
        {
          case "EURO":
            type = "EUR";
            break;
          
          case "BLOK":
            type = "IND";
            break;
          
          default:
            type = packageType.ToUpper().Substring(0, 3);
            break;
        }
        
       return type + GetPackageQty("IN").ToString("000") + type + GetPackageQty("OUT").ToString("000");
    }
		]]>
  </msxsl:script>
</xsl:stylesheet>