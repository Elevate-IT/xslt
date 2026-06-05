<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/sendsalesinvoiceledger:v1.00"
                exclude-result-prefixes = "#all" >
  <xsl:output method="xml" indent="yes"/>
  
  
  
  
  <xsl:variable name="CustomerLedgerAmount" select="/ns0:Message/ns0:SalesInvoices/ns0:SalesInvoice/ns0:CustomerLedgerEntries[1]/ns0:CustLedgerEntry[1]/ns0:Amount[1]" />
  <xsl:variable name="TransactionType">
    <xsl:value-of select="if(substring($CustomerLedgerAmount,1,1) = '-')then('21')else('20')"/>
  </xsl:variable>
  <xsl:variable name="DocumentType">
    <xsl:value-of select="if(substring($CustomerLedgerAmount,1,1) = '-')then('10')else('20')"/>
  </xsl:variable>
  
  
  
  <xsl:template match="/">
    <xsl:for-each select="/ns0:Message/ns0:SalesInvoices/ns0:SalesInvoice">
      <eExact  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <GLTransactions>
          <GLTransaction>
            <xsl:attribute name="entry">
              <xsl:value-of select="substring-after(ns0:No,'SHIFT_INV')"/>
            </xsl:attribute>
            <TransactionType number="{$TransactionType}"/>
            <Journal>
              <xsl:attribute name="code">
                <xsl:value-of>700</xsl:value-of>
              </xsl:attribute>
              <!-- <Description><xsl:value-of select="ns0:SourceCode"/></Description> -->
              <GLAccount>
                <xsl:attribute name="code">
                  <xsl:value-of>400000</xsl:value-of>
                </xsl:attribute>
                <xsl:attribute name="type">
                  <xsl:value-of>20</xsl:value-of>
                </xsl:attribute>
              </GLAccount>
            </Journal>
            <xsl:if test="string-length(ns0:Customer/ns0:PaymentTermsCode)&gt;0" >
              <PaymentCondition>
                <xsl:attribute name="code">
                  <xsl:value-of select="substring(ns0:Customer/ns0:PaymentTermsCode, 0, string-length(ns0:Customer/ns0:PaymentTermsCode))"/>
                  
                </xsl:attribute>
                <Description>
                  <xsl:value-of select="substring(ns0:Customer/ns0:PaymentTermsCode, 0, string-length(ns0:Customer/ns0:PaymentTermsCode))"/>
                </Description>
              </PaymentCondition>
            </xsl:if>
            <Date>
              <xsl:value-of select="ns0:PostingDate" />
            </Date>
            
            <xsl:variable name="FinYear" select="number(substring(ns0:PostingDate,1,4))" />
            <xsl:variable name="FinPeriod" select="number(substring(ns0:PostingDate,6,2))" />
            <!-- logic adjusted for request 6082 -->
            <xsl:choose>
              <xsl:when test="$FinYear &lt; 2026">
                <xsl:choose>
                  <xsl:when test="$FinPeriod &lt; 10">
                    <FinYear>
                      <xsl:attribute name="number">
                        <xsl:value-of select="$FinYear"/>
                      </xsl:attribute>
                    </FinYear>
                    <FinPeriod>
                      <xsl:attribute name="number">
                        <xsl:value-of select="format-number($FinPeriod + 3, '00')"/>
                      </xsl:attribute>
                    </FinPeriod>
                  </xsl:when>
                  <xsl:otherwise>
                    <FinYear>
                      <xsl:attribute name="number">
                        <xsl:value-of select="$FinYear + 1"/>
                      </xsl:attribute>
                    </FinYear>
                    <FinPeriod>
                      <xsl:attribute name="number">
                        <xsl:value-of select="format-number($FinPeriod - 9, '00')"/>
                      </xsl:attribute>
                    </FinPeriod>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="$FinYear = 2026">
                <FinYear>
                  <xsl:attribute name="number">
                    <xsl:value-of select="$FinYear"/>
                  </xsl:attribute>
                </FinYear>
                <FinPeriod>
                  <xsl:attribute name="number">
                    <xsl:value-of select="format-number($FinPeriod + 3, '00')"/>
                  </xsl:attribute>
                </FinPeriod>
              </xsl:when>
              <xsl:otherwise>
                <FinYear>
                  <xsl:attribute name="number">
                    <xsl:value-of select="$FinYear"/>
                  </xsl:attribute>
                </FinYear>
                <FinPeriod>
                  <xsl:attribute name="number">
                    <xsl:value-of select="format-number($FinPeriod, '00')"/>
                  </xsl:attribute>
                </FinPeriod>
              </xsl:otherwise>
            </xsl:choose>
            
            
            <Document>
              <Subject>
                <xsl:value-of select="ns0:PostingDescription"/>
              </Subject>
              <Description>
                <xsl:value-of select="concat(ns0:Customer/ns0:Name,' ',ns0:No)"/>
              </Description>
              <DocumentType number="{$DocumentType}">
                <Description>Sales Invoice</Description>
              </DocumentType>
              <!-- <Account>
                   <xsl:attribute name="code">
                   <xsl:value-of select="ns0:Customer/ns0:No2"/>
                   </xsl:attribute>
                   </Account> -->
              <Account>
                <xsl:attribute name="code">
                  <xsl:value-of select="translate(//ns0:Customer/ns0:No,translate(//ns0:Customer/ns0:No,'0123456789',''),'')" />
                </xsl:attribute>
              </Account>
              <Date>
                <xsl:value-of  select="ns0:PostingDate"/>
              </Date>
              <References>
                <Sales>
                  <InvoiceNumber>
                    <xsl:value-of select="ns0:No"/>
                  </InvoiceNumber>
                </Sales>
                <YourRef>
                  <xsl:value-of select="ns0:No"/>
                </YourRef>
              </References>
              <Attachments>
                <xsl:for-each select="ns0:LinkedDocuments/ns0:LinkedDocument">
                  <Attachment>
                    <Name>
                      <xsl:value-of select="ns0:Description" />
                    </Name>
                    <BinaryData>
                      <xsl:value-of select="ns0:EncodedPDF"/>
                    </BinaryData>
                  </Attachment>
                </xsl:for-each>
              </Attachments>
            </Document>
            <!-- <Account>
                 <xsl:attribute name="code">
                 <xsl:value-of select="//ns0:Customer/ns0:No2" />
                 </xsl:attribute>
                 </Account> -->
            <Account>
              <xsl:attribute name="code">
                <xsl:value-of select="translate(//ns0:Customer/ns0:No,translate(//ns0:Customer/ns0:No,'0123456789',''),'')" />
              </xsl:attribute>
            </Account>
            <xsl:for-each select="ns0:GLEntries/ns0:GLEntry" >
              <xsl:call-template name="GLTransactionLine">
                <xsl:with-param name="VATAmount" select="ns0:VATAmount"/>
                <xsl:with-param name="GLAccountNo" select="ns0:GLAccountNo"/>
                <xsl:with-param name="VATBusPostingGroup" select="ns0:VATBusPostingGroup"/>
                <xsl:with-param name="VATProdPostingGroup" select="ns0:VATProdPostingGroup"/>
              </xsl:call-template>
            </xsl:for-each>
          </GLTransaction>
        </GLTransactions>
      </eExact>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="GLTransactionLine">
    <xsl:param name="VATAmount"/>
    <xsl:param name="GLAccountNo"/>
    <xsl:param name="VATBusPostingGroup"/>
    <xsl:param name="VATProdPostingGroup"/>
    <GLTransactionLine>
      <GLAccount>
        <xsl:attribute name="code">
          <xsl:choose>
            <xsl:when test="$GLAccountNo = '1300'">
              <xsl:text>400000</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$GLAccountNo" />
            </xsl:otherwise>
          </xsl:choose>
          <!-- <xsl:attribute name="code">
               <xsl:value-of select="$GLAccountNo" /> -->
           </xsl:attribute>
      </GLAccount>
      <Description>
        <xsl:value-of select="substring(ns0:Description,1,255)" />
      </Description>
      <DueDate>
        <xsl:value-of select="../../ns0:DueDate"/>
      </DueDate>
      <InvoiceDate>
        <xsl:value-of select="../../ns0:PostingDate"/>
      </InvoiceDate>
      <!-- <xsl:if test="ns0:GlobalDimension1Code">
           <Costcenter>
           <xsl:attribute name="code" >
           <xsl:value-of select="ns0:GlobalDimension1Code"/>
           </xsl:attribute>
           </Costcenter>
           </xsl:if> 
           <xsl:if test="ns0:GlobalDimension2Code">
           <Costunit>
           <xsl:attribute name="code" >
           <xsl:value-of select="ns0:GlobalDimension2Code"/>
           </xsl:attribute>
           </Costunit>
           </xsl:if>
      -->
      <Amount>
        <Currency>
          <xsl:attribute name="code" >
            <xsl:text>EUR</xsl:text>
          </xsl:attribute>
        </Currency>
        <Value>
          <xsl:value-of select="if(ns0:CreditAmount!=0)then(concat('-',ns0:CreditAmount))else(ns0:DebitAmount)" />
        </Value>
        <xsl:if test="string-length(../../ns0:VATLedgerEntries/ns0:VATLedgerEntry[ns0:AccountNo=current()/ns0:GLAccountNo][1]/ns0:VATIdentifier)&gt;0" >
          <VAT>
            <xsl:attribute name="code" >
              <xsl:value-of select="substring(../../ns0:VATLedgerEntries/ns0:VATLedgerEntry[ns0:AccountNo = $GLAccountNo][ns0:VATBusPostingGroup = $VATBusPostingGroup][ns0:VATProdPostingGroup = $VATProdPostingGroup][1]/ns0:VATIdentifier,1,1)"/>
            </xsl:attribute>
          </VAT>
        </xsl:if>
        <xsl:if test="$VATAmount!=0">
          <VATBaseAmount>
            <xsl:value-of select="if(ns0:CreditAmount!=0)then(concat('-',ns0:CreditAmount))else(ns0:DebitAmount)" />
          </VATBaseAmount>
        </xsl:if>
      </Amount>
      <References>
        <InvoiceNumber>
          <xsl:value-of select="../../ns0:No"/>
        </InvoiceNumber>
        <YourRef>
          <xsl:value-of select="../../ns0:No"/>
        </YourRef>
        <PaymentReference>
          <xsl:value-of select="concat(../../ns0:No, '/', ../../ns0:Customer/ns0:No)"/>
        </PaymentReference>
      </References>
    </GLTransactionLine>
  </xsl:template>
</xsl:stylesheet>