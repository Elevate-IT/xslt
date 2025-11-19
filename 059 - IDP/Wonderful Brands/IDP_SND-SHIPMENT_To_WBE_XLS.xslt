<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="no" indent="yes"/>
  <xsl:key name="Group-by-Item-Batch-ExpDate" match="//s0:Carrier/s0:Contents/s0:Content" use="concat(s0:ExternalNo, '-', s0:ExternalBatchNo, '-', s0:ExpirationDate)" />

  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <xsl:variable name="DetLineKey" select="//s0:DocumentDetailLine/s0:CarrierNo" />
    <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
      <Styles>
        <Style ss:ID="header" ss:Name="Normal">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s1">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="11" ss:Bold="1"/>
          <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s2">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="8" ss:Bold="1"/>
          <Interior ss:Color="#FFF2CC" ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s3">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="8"/>
          <Interior ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s4">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="8" ss:Bold="1"/>
          <!--<Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>-->
        </Style>
        <Style ss:ID="s5">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Font ss:FontName="Calibri" ss:Size="8" ss:Bold="1"/>
          <Interior ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s6">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Font ss:FontName="Calibri" ss:Size="18.5" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s7">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="8" ss:Bold="1"/>
          <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s8">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="7" ss:Bold="1"/>
          <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s9">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Font ss:FontName="Calibri" ss:Size="18.5" ss:Bold="1" ss:Color="#1aa003"/>
        </Style>
        <Style ss:ID="s10">
          <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
          <Font ss:FontName="Calibri" ss:Size="6" ss:Color="#b2aea6"/>
        </Style>
        <Style ss:ID="s11">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="8"/>
        </Style>
        <Style ss:ID="s12">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Bold="1" ss:Size="10"/>
        </Style>
      </Styles>
      <Worksheet ss:Name="Delivery Note">
        <Table>
          <Column ss:Index="1" ss:Width="58"/>
          <Column ss:Index="2" ss:Width="228"/>
          <Column ss:Index="3" ss:Width="42"/>
          <Column ss:Index="4" ss:Width="53"/>
          <Column ss:Index="5" ss:Width="37"/>
          <Column ss:Index="6" ss:Width="37"/>
          <Column ss:Index="7" ss:Width="37"/>
          <Column ss:Index="8" ss:Width="37"/>
          <Column ss:Index="9" ss:Width="37"/>
          <Column ss:Index="10" ss:Width="37"/>
          <Column ss:Index="11" ss:Width="37"/>
          <Column ss:Index="12" ss:Width="37"/>
          <Column ss:Index="13" ss:Width="53"/>
          <Row ss:Index="1" ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s9">
              <Data ss:Type="String">Wonderful brands</Data>
            </Cell>
            <Cell ss:Index="3" ss:MergeAcross="2" ss:StyleID="s1">
              <Data ss:Type="String">FROM</Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="2" ss:StyleID="s2">
              <Data ss:Type="String">INVOICE NUMBER</Data>
            </Cell>
            <Cell ss:Index="11" ss:MergeAcross="2" ss:StyleID="s2">
              <Data ss:Type="String">REMARKS</Data>
            </Cell>
          </Row>
          <Row ss:Index="2" ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s10">
              <Data ss:Type="String">Europe, Middle East and Africa</Data>
            </Cell>
            <!--FROM-->
            <Cell ss:Index="3" ss:MergeAcross="2" ss:MergeDown="2" ss:StyleID="s3">
              <Data ss:Type="String">
                <xsl:choose>
                  <xsl:when test="s0:SenderAddress/s0:No != ''">
                    <xsl:value-of select="s0:SenderAddress/s0:Name"/>
                    <xsl:text disable-output-escaping="yes">&amp;#10;</xsl:text>
                    <xsl:value-of select="s0:SenderAddress/s0:Address"/>
                    <xsl:text disable-output-escaping="yes">&amp;#10;</xsl:text>
                    <xsl:value-of select="concat(s0:SenderAddress/s0:PostCode,' ',s0:SenderAddress/s0:City,', ',s0:SenderAddress/s0:CountryRegionCode)" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="concat('IDP NV', '&amp;#10;', 'Zuidkaai 5', '&amp;#10;', '2170 Merksem, BE')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </Data>
            </Cell>
            <!--Invoice Number-->
            <Cell ss:Index="7" ss:MergeAcross="2" ss:StyleID="s3">
              <Data ss:Type="String">
                <xsl:value-of select="s0:ExternalDocumentNo"/>
              </Data>
            </Cell>
            <!--Remarks-->
            <Cell ss:Index="11" ss:MergeAcross="2" ss:MergeDown="6" ss:StyleID="s4">
              <Data ss:Type="String"></Data>
            </Cell>
          </Row>
          <Row ss:Index="3" ss:Height="10">
            <!--Adress-->
            <Cell ss:Index="2" ss:MergeDown="2" ss:StyleID="s5">
              <Data ss:Type="String">
                <xsl:value-of select="s0:Customer/s0:Name"/>
                <xsl:text disable-output-escaping="yes">&amp;#10;</xsl:text>
                <xsl:value-of select="s0:Customer/s0:Address"/>
                <xsl:text disable-output-escaping="yes">&amp;#10;</xsl:text>
                <xsl:value-of select="concat(s0:Customer/s0:City,' ',s0:Customer/s0:PostCode,', ',s0:Customer/s0:CountryName)" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="4" ss:Height="20">
            <Cell ss:Index="7" ss:MergeAcross="2" ss:StyleID="s2">
              <Data ss:Type="String">PICK UP DATE</Data>
            </Cell>
          </Row>
          <Row ss:Index="5" ss:Height="20">
            <Cell ss:Index="3" ss:MergeAcross="2" ss:StyleID="s1">
              <Data ss:Type="String">TO</Data>
            </Cell>
            <!--Pick Up Date-->
            <Cell ss:Index="7" ss:MergeAcross="2" ss:StyleID="s3">
              <Data ss:Type="String">
                <xsl:value-of select="translate(MyScript:ParseDate(s0:DepartedDate,'yyyy-MM-dd','dd/MM/yyyy'), '-', '/')" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="6" ss:Height="10">
            <!--To-->
            <Cell ss:Index="3" ss:MergeAcross="2" ss:MergeDown="2" ss:StyleID="s3">
              <Data ss:Type="String">
                <xsl:value-of select="s0:ShipToAddress/s0:Name"/>
                <xsl:text disable-output-escaping="yes">&amp;#10;</xsl:text>
                <xsl:value-of select="s0:ShipToAddress/s0:Address"/>
                <xsl:text disable-output-escaping="yes">&amp;#10;</xsl:text>
                <xsl:value-of select="concat(s0:ShipToAddress/s0:PostCode,' ',s0:ShipToAddress/s0:City,', ',s0:ShipToAddress/s0:CountryRegionCode)" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="7" ss:Height="20">
            <Cell ss:Index="1" ss:MergeAcross="1" ss:MergeDown="1" ss:StyleID="s6">
              <Data ss:Type="String">DELIVERY NOTE</Data>
            </Cell>
            <!--<Cell ss:Index="7" ss:MergeAcross="2" ss:StyleID="s2">
              <Data ss:Type="String">DELIVERY DATE</Data>
            </Cell>-->
          </Row>
          <Row ss:Index="8" ss:Height="20">
            <!--Delivery Date-->
            <!--<Cell ss:Index="7" ss:MergeAcross="2" ss:StyleID="s3">
              <Data ss:Type="String"></Data>
            </Cell>-->
          </Row>
          <Row ss:Index="9" ss:Height="10"/>
          <Row ss:Index="10" ss:Height="13">
            <Cell ss:Index="1" ss:MergeAcross="3" ss:StyleID="s7">
              <Data ss:Type="String">PRODUCT INFORMATION</Data>
            </Cell>
            <Cell ss:Index="5" ss:MergeAcross="1" ss:StyleID="s7">
              <Data ss:Type="String">FROM</Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s7">
              <Data ss:Type="String">TO</Data>
            </Cell>
            <Cell ss:Index="9" ss:MergeAcross="4" ss:StyleID="s7">
              <Data ss:Type="String">AMOUNT</Data>
            </Cell>
          </Row>
          <Row ss:Index="11">
            <Cell ss:Index="1" ss:StyleID="s8">
              <Data ss:Type="String">Item Number</Data>
            </Cell>
            <Cell ss:Index="2" ss:StyleID="s8">
              <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:Index="3" ss:StyleID="s8">
              <Data ss:Type="String">Lot Number</Data>
            </Cell>
            <Cell ss:Index="4" ss:StyleID="s8">
              <Data ss:Type="String">Best Before Date</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s8">
              <Data ss:Type="String">WHS</Data>
            </Cell>
            <Cell ss:Index="6" ss:StyleID="s8">
              <Data ss:Type="String">Locator</Data>
            </Cell>
            <Cell ss:Index="7" ss:StyleID="s8">
              <Data ss:Type="String">WHS</Data>
            </Cell>
            <Cell ss:Index="8" ss:StyleID="s8">
              <Data ss:Type="String">Locator</Data>
            </Cell>
            <Cell ss:Index="9" ss:StyleID="s8">
              <Data ss:Type="String">Quantity</Data>
            </Cell>
            <Cell ss:Index="10" ss:StyleID="s8">
              <Data ss:Type="String">UoM</Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s8">
              <Data ss:Type="String">Mxk-ref</Data>
            </Cell>
            <Cell ss:Index="12" ss:StyleID="s8">
              <Data ss:Type="String">Pallets</Data>
            </Cell>
            <Cell ss:Index="13" ss:StyleID="s8">
              <Data ss:Type="String">Weight (kg)</Data>
            </Cell>
          </Row>

          <xsl:for-each select="//s0:Carrier/s0:Contents/s0:Content[count(. | key('Group-by-Item-Batch-ExpDate', concat(s0:ExternalNo, '-', s0:ExternalBatchNo, '-', s0:ExpirationDate))[1]) = 1]">
            <xsl:variable name="LineKey" select="concat(s0:ExternalNo, '-', s0:ExternalBatchNo, '-', s0:ExpirationDate)" />
            <xsl:variable name="DocLineNo" select="s0:DocumentLineNo" />
            <xsl:if test="concat(s0:ExternalNo, '-', s0:ExternalBatchNo, '-', s0:ExpirationDate) != '--'">
              <Row>
                <!--Item Number-->
                <Cell ss:Index="1" ss:StyleID="s11">
                  <Data ss:Type="String">
                    <xsl:value-of select="s0:ExternalNo"/>
                  </Data>
                </Cell>
                <!--Description-->
                <Cell ss:Index="2" ss:StyleID="s11">
                  <Data ss:Type="String">
                    <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $DocLineNo]/s0:Description"/>
                  </Data>
                </Cell>
                <!--Lot Number-->
                <Cell ss:Index="3" ss:StyleID="s11">
                  <Data ss:Type="String">
                    <xsl:value-of select="s0:ExternalBatchNo"/>
                  </Data>
                </Cell>
                <!--Best Before Date-->
                <Cell ss:Index="4" ss:StyleID="s11">
                  <Data ss:Type="String">
                    <xsl:value-of select="translate(MyScript:ParseDate(s0:ExpirationDate,'yyyy-MM-dd','dd/MM/yyyy'), '-', '/')"/>
                  </Data>
                </Cell>
                <!--FROM WHS-->
                <Cell ss:Index="5" ss:StyleID="s11">
                  <Data ss:Type="String">IDP</Data>
                </Cell>
                <!--FROM Locator-->
                <Cell ss:Index="6" ss:StyleID="s11">
                  <Data ss:Type="String">IDP 1</Data>
                </Cell>
                <!--TO WHS-->
                <Cell ss:Index="7" ss:StyleID="s11">
                  <Data ss:Type="String"></Data>
                </Cell>
                <!--TO Locator-->
                <Cell ss:Index="8" ss:StyleID="s11">
                  <Data ss:Type="String"></Data>
                </Cell>
                <!--Quantity-->
                <Cell ss:Index="9" ss:StyleID="s11">
                  <Data ss:Type="String">
                    <xsl:value-of select="sum(key('Group-by-Item-Batch-ExpDate', $LineKey)/s0:Quantity)" />
                  </Data>
                </Cell>
                <!--UoM-->
                <Cell ss:Index="10" ss:StyleID="s11">
                  <Data ss:Type="String">
                    <xsl:value-of select="s0:UnitofMeasureCode" />
                  </Data>
                </Cell>
                <!--MXK-ref-->
                <Cell ss:Index="11" ss:StyleID="s11">
                  <Data ss:Type="String"></Data>
                </Cell>
                <!--Pallets-->
                <Cell ss:Index="12" ss:StyleID="s11">
                  <Data ss:Type="String">
                    <xsl:value-of select="count(//s0:Carrier[concat(s0:Contents/s0:Content/s0:ExternalNo, '-', s0:Contents/s0:Content/s0:ExternalBatchNo, '-', s0:Contents/s0:Content/s0:ExpirationDate) = $LineKey])" />
                  </Data>
                </Cell>
                <!--Weight (kg)-->
                <Cell ss:Index="13" ss:StyleID="s11">
                  <Data ss:Type="String">
                    <xsl:value-of select="sum(key('Group-by-Item-Batch-ExpDate', $LineKey)/s0:GrossWeight)" />
                  </Data>
                </Cell>
              </Row>
            </xsl:if>
          </xsl:for-each>

          <Row>
            <!--Empty Line-->
            <Cell ss:Index="1" ss:StyleID="s11"/>
            <Cell ss:Index="2" ss:StyleID="s11"/>
            <Cell ss:Index="3" ss:StyleID="s11"/>
            <Cell ss:Index="4" ss:StyleID="s11"/>
            <Cell ss:Index="5" ss:StyleID="s11"/>
            <Cell ss:Index="6" ss:StyleID="s11"/>
            <Cell ss:Index="7" ss:StyleID="s11"/>
            <Cell ss:Index="8" ss:StyleID="s11"/>
            <Cell ss:Index="9" ss:StyleID="s11"/>
            <Cell ss:Index="10" ss:StyleID="s11"/>
            <Cell ss:Index="11" ss:StyleID="s11"/>
            <Cell ss:Index="12" ss:StyleID="s11"/>
            <Cell ss:Index="13" ss:StyleID="s11"/>
          </Row>
          <Row>
            <Cell ss:Index="1" ss:StyleID="s11"/>
            <Cell ss:Index="2" ss:MergeAcross="4" ss:MergeDown="1" ss:StyleID="s12">
              <Data ss:Type="String">
                <xsl:value-of disable-output-escaping="yes" select="concat('0% VAT as a result of a intracommunity supply due to art 138-1', '&amp;#10;', 'VAT Directive 2006-112EC')" />
              </Data>
            </Cell>
            <Cell ss:Index="7" ss:StyleID="s11"/>
            <Cell ss:Index="8" ss:StyleID="s11"/>
            <Cell ss:Index="9" ss:StyleID="s11"/>
            <Cell ss:Index="10" ss:StyleID="s11"/>
            <Cell ss:Index="11" ss:StyleID="s11"/>
            <Cell ss:Index="12" ss:StyleID="s11"/>
            <Cell ss:Index="13" ss:StyleID="s11"/>
          </Row>
          <Row>
            <Cell ss:Index="1" ss:StyleID="s11"/>
            <Cell ss:Index="7" ss:StyleID="s11"/>
            <Cell ss:Index="8" ss:StyleID="s11"/>
            <Cell ss:Index="9" ss:StyleID="s11"/>
            <Cell ss:Index="10" ss:StyleID="s11"/>
            <Cell ss:Index="11" ss:StyleID="s11"/>
            <Cell ss:Index="12" ss:StyleID="s11"/>
            <Cell ss:Index="13" ss:StyleID="s11"/>
          </Row>
          <Row>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s12">
              <Data ss:Type="String">Total:</Data>
            </Cell>
            <Cell ss:Index="9" ss:MergeAcross="1" ss:StyleID="s12">
              <Data ss:Type="String">
                <xsl:value-of select="concat(sum(//s0:Carrier/s0:Contents/s0:Content/s0:Quantity), ' case(s)')" />
              </Data>
            </Cell>
            <Cell ss:Index="11" ss:MergeAcross="1" ss:StyleID="s12">
              <Data ss:Type="String">
                <xsl:value-of select="concat(count(//s0:Carrier), ' pallet(s)')" />
              </Data>
            </Cell>
            <Cell ss:Index="13" ss:StyleID="s12">
              <Data ss:Type="String">
                <xsl:value-of select="concat(sum(//s0:Carrier/s0:Contents/s0:Content/s0:GrossWeight), ' kg')" />
              </Data>
            </Cell>
          </Row>
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
          <PageSetup>
            <Layout x:Orientation="Landscape"/>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.5" x:Left="0.25" x:Right="0.25" x:Top="0.5"/>
          </PageSetup>
        </WorksheetOptions>
      </Worksheet>
    </Workbook>
  </xsl:template>

  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseEOMDate(string input, string formatIn, string formatOut)
      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        DateTime endOfMonth = new DateTime(dateT.Year, dateT.Month, DateTime.DaysInMonth(dateT.Year, dateT.Month));
        return endOfMonth.ToString(formatOut);
      }
      
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string TrimEnd(string input)
      {
        return input.TrimEnd();
      }
      
      public int rowNr = 0;
      public string GetRowNr(int offset)
      {
        if (rowNr == 0)
          rowNr += offset;
          
        rowNr += 1;
          
        return rowNr.ToString();
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>
