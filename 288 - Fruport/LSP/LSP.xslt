<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:key name="GroupBy-FreeCirculation__" match="//Trip/Shipment"
    use="concat(Documents/Document/Carriers/Carrier/ContentLines/CarrierContent/ExternalCustomerItemNo, '-', Documents/Document/Carriers/Carrier/ContentLines/CarrierContent/ExBatchNo, '-', Documents/Document/Carriers/Carrier/ContentLines/CarrierContent/ExpirationDate)" />
  <xsl:key name="GroupBy-FreeCirculation" match="//Trip/Shipment"
    use="DocumentDetailLine/FreeCirculation/No" />
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="Trip">
    <xsl:element name="UserID">
      <xsl:value-of select="UserID" />
    </xsl:element>
    
    <xsl:for-each select="Shipment">
      
      <xsl:element name="Shipment">
        <xsl:choose>
          <xsl:when test="OrderTypeCode = 'COMUNITARIO'">
            <xsl:for-each-group select="DocumentDetailLine" group-by="Description">
              
              <xsl:element name="LSP">
                <xsl:element name="Cabecera">
                  <xsl:element name="NumMensaje">
                    <xsl:value-of select="../../No" />
                  </xsl:element>
                  <xsl:element name="FechaEnvio">
                    <xsl:value-of select="format-dateTime(/Message/Header/CreationDateTime, '[Y][M,2][D,2][H,2][m,2]')" />
                  </xsl:element>
                  <xsl:element name="Emisor">
                    <xsl:text>0013</xsl:text>
                  </xsl:element>
                  <xsl:element name="Receptor">
                    <xsl:text>APTA</xsl:text>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="LSP_COMUN">
                  <xsl:element name="Recinto">
                    <xsl:text>4311</xsl:text>
                  </xsl:element>
                  <xsl:element name="Vehiculo">
                    <xsl:value-of select="../VehicleNo" />
                    
                  </xsl:element>
                  <xsl:element name="Mercancia">
                    <xsl:value-of select="Description" />
                  </xsl:element>
                  <xsl:element name="NumAlbaran">
                    <xsl:value-of select="substring(../No,2,8)" />
                  </xsl:element>
                  <xsl:element name="FechaAlbaran">
                    <xsl:value-of select="concat(format-date(../../ActualDepartureDate, '[Y][M,2][D,2]'),format-time(../../ActualDepartureTime, '[H,2][m,2]'))" />
                  </xsl:element>
                  <xsl:element name="Terminal">
                    <xsl:text>13</xsl:text>
                  </xsl:element>
                  <xsl:element name="Escala">COMUNITARIO</xsl:element>
                  <xsl:element name="Destino">COMUNITARIO</xsl:element>
                </xsl:element>
                <xsl:element name="LSP_GRANEL">
                  <xsl:element name="Bascula">
                    <xsl:text>30</xsl:text>
                  </xsl:element>
                  <xsl:element name="FechaPesaje">
                    <xsl:value-of select="format-dateTime(/Message/Header/CreationDateTime, '[Y][M,2][D,2][H,2][m,2]')" />
                    
                  </xsl:element>
                  <xsl:element name="TicketPesaje">
                    <xsl:value-of select="/Message/Header/MessageID" />
                  </xsl:element>
                  <xsl:element name="CodigoUnidad">
                    <xsl:text>U</xsl:text>
                  </xsl:element>
                  <xsl:element name="NumeroUnidades">
                    <xsl:value-of select="sum(current-group()/Quantity)" />
                  </xsl:element>
                  <xsl:element name="TipoDoc">
                    <xsl:text>AAT</xsl:text>
                  </xsl:element>
                  
                  <xsl:element name="RecDoc">
                    <xsl:text>4311</xsl:text>
                  </xsl:element>
                  <xsl:element name="NumDoc">
                    <xsl:text>43FRUP</xsl:text>
                  </xsl:element>
                  
                  
                </xsl:element>
                
              </xsl:element>
              
            </xsl:for-each-group>
          </xsl:when>
          <xsl:otherwise>
            
            
            <xsl:for-each-group select="DocumentDetailLine" group-by="FreeCirculation/DeclarationDocumentType">
              <xsl:choose>
                <xsl:when test="FreeCirculation/DeclarationDocumentType = 'TEX'">
                  <xsl:for-each-group select="current-group()" group-by="FreeCirculation/DeclarationDocumentNo">
                    <xsl:element name="LSP">
                      <xsl:element name="Cabecera">
                        <xsl:element name="NumMensaje">
                          <xsl:value-of select="../../No" />
                        </xsl:element>
                        <xsl:element name="FechaEnvio">
                          <xsl:value-of select="format-dateTime(/Message/Header/CreationDateTime, '[Y][M,2][D,2][H,2][m,2]')" />
                        </xsl:element>
                        <xsl:element name="Emisor">
                          <xsl:text>0013</xsl:text>
                        </xsl:element>
                        <xsl:element name="Receptor">
                          <xsl:text>APTA</xsl:text>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="LSP_COMUN">
                        <xsl:element name="Recinto">
                          <xsl:text>4311</xsl:text>
                        </xsl:element>
                        <xsl:element name="Vehiculo">
                          <xsl:value-of select="../VehicleNo" />
                          
                        </xsl:element>
                        <xsl:element name="Mercancia">
                          <xsl:value-of select="Description" />
                        </xsl:element>
                        <xsl:element name="NumAlbaran">
                          <xsl:value-of select="substring(../No,2,8)" />
                        </xsl:element>
                        <xsl:element name="FechaAlbaran">
                          <xsl:value-of select="concat(format-date(../../ActualDepartureDate, '[Y][M,2][D,2]'),format-time(../../ActualDepartureTime, '[H,2][m,2]'))" />
                        </xsl:element>
                        <xsl:element name="Terminal">
                          <xsl:text>13</xsl:text>
                        </xsl:element>
                        <xsl:element name="Escala">
                        </xsl:element>
                        <xsl:element name="Destino">
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="LSP_GRANEL">
                        <xsl:element name="Bascula">
                          <xsl:text>30</xsl:text>
                        </xsl:element>
                        <xsl:element name="FechaPesaje">
                          <xsl:value-of select="format-dateTime(/Message/Header/CreationDateTime, '[Y][M,2][D,2][H,2][m,2]')" />
                          
                        </xsl:element>
                        <xsl:element name="TicketPesaje">
                          <xsl:value-of select="/Message/Header/MessageID" />
                        </xsl:element>
                        <xsl:element name="CodigoUnidad">
                          <xsl:text>U</xsl:text>
                        </xsl:element>
                        <xsl:element name="NumeroUnidades">
                          <xsl:choose>
                            <xsl:when test="FreeCirculation/IncoTermsCode = 'CAJAS'">
                              <xsl:value-of select="sum(current-group()/Quantity)" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="count(current-group())" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                        <xsl:element name="TipoDoc">
                          <xsl:value-of select="FreeCirculation/DeclarationDocumentType" />
                        </xsl:element>
                        <xsl:element name="NumDUA">
                          <xsl:value-of select="FreeCirculation/DeclarationDocumentNo" />
                        </xsl:element>
                        <xsl:element name="NumPartida">
                          <xsl:text>000</xsl:text>
                        </xsl:element>
                        
                      </xsl:element>
                    </xsl:element>
                  </xsl:for-each-group>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each-group select="current-group()" group-by="concat(FreeCirculation/DeclarationDocumentNo, '|', FreeCirculation/Partida)">
                    <xsl:element name="LSP">
                      
                      <xsl:element name="Cabecera">
                        <xsl:element name="NumMensaje">
                          <xsl:value-of select="../../No" />
                        </xsl:element>
                        <xsl:element name="FechaEnvio">
                          <xsl:value-of select="format-dateTime(/Message/Header/CreationDateTime, '[Y][M,2][D,2][H,2][m,2]')" />
                        </xsl:element>
                        <xsl:element name="Emisor">
                          <xsl:text>0013</xsl:text>
                        </xsl:element>
                        <xsl:element name="Receptor">
                          <xsl:text>APTA</xsl:text>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="LSP_COMUN">
                        <xsl:element name="Recinto">
                          <xsl:text>4311</xsl:text>
                        </xsl:element>
                        <xsl:element name="Vehiculo">
                          <xsl:value-of select="../VehicleNo" />
                          
                        </xsl:element>
                        <xsl:element name="Mercancia">
                          <xsl:value-of select="Description" />
                        </xsl:element>
                        <xsl:element name="NumAlbaran">
                          <xsl:value-of select="substring(../No,2,8)" />
                        </xsl:element>
                        <xsl:element name="FechaAlbaran">
                          <xsl:value-of select="concat(format-date(../../ActualDepartureDate, '[Y][M,2][D,2]'),format-time(../../ActualDepartureTime, '[H,2][m,2]'))" />
                        </xsl:element>
                        <xsl:element name="Terminal">
                          <xsl:text>13</xsl:text>
                        </xsl:element>
                        <xsl:element name="Escala">
                        </xsl:element>
                        <xsl:element name="Destino">
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="LSP_GRANEL">
                        <xsl:element name="Bascula">
                          <xsl:text>30</xsl:text>
                        </xsl:element>
                        <xsl:element name="FechaPesaje">
                          <xsl:value-of select="format-dateTime(/Message/Header/CreationDateTime, '[Y][M,2][D,2][H,2][m,2]')" />
                          
                        </xsl:element>
                        <xsl:element name="TicketPesaje">
                          <xsl:value-of select="/Message/Header/MessageID" />
                        </xsl:element>
                        <xsl:element name="CodigoUnidad">
                          <xsl:text>U</xsl:text>
                        </xsl:element>
                        <xsl:element name="NumeroUnidades">
                          <xsl:choose>
                            <xsl:when test="FreeCirculation/IncoTermsCode = 'CAJAS'">
                              <xsl:value-of select="sum(current-group()/Quantity)" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="count(current-group())" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                        <xsl:element name="TipoDoc">
                          <xsl:choose>
                            <xsl:when test="FreeCirculation/DeclarationDocumentType = 'LIB'">
                              <xsl:text>DUA</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="FreeCirculation/DeclarationDocumentType" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                        
                        <xsl:choose>
                          <xsl:when test="FreeCirculation/DeclarationDocumentType = 'STO'">
                            
                            <xsl:element name="RecDoc">
                              <xsl:value-of select="substring(FreeCirculation/DeclarationDocumentNo, 5, 4)" />
                            </xsl:element>
                            <xsl:element name="Anio">
                              <xsl:value-of select="substring(FreeCirculation/DeclarationDocumentNo, 12, 1)" />
                              
                            </xsl:element>
                            <xsl:element name="NumDoc">
                              <xsl:value-of select="substring(FreeCirculation/DeclarationDocumentNo, 13, 6)" />
                              
                            </xsl:element>
                            <xsl:element name="NumPartida">
                              <xsl:value-of select="FreeCirculation/Partida" />
                            </xsl:element>
                          </xsl:when>
                          <xsl:otherwise>
                            
                            
                            <xsl:element name="NumDUA">
                              <xsl:value-of select="FreeCirculation/DeclarationDocumentNo" />
                            </xsl:element>
                            <xsl:element name="NumPartida">
                              <xsl:choose>
                                <xsl:when test="FreeCirculation/DeclarationDocumentType = 'TEX'">
                                  <xsl:text>000</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="FreeCirculation/Partida" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:element>
                          </xsl:otherwise></xsl:choose>
                        
                      </xsl:element>
                      
                    </xsl:element>
                  </xsl:for-each-group>
                </xsl:otherwise>
              </xsl:choose>
              
            </xsl:for-each-group>
            
          </xsl:otherwise>
        </xsl:choose>
        
        
      </xsl:element></xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
