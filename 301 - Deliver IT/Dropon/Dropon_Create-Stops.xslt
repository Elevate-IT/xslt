<xsl:stylesheet version="3.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2005/xpath-functions"
                xmlns:ns0="www.boltrics.nl/sendtmsdocument:v1.00">
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//ns0:Message/ns0:Documents/ns0:Document" />
    </xsl:template>
    
    <xsl:template match="//ns0:Message/ns0:Documents/ns0:Document">
        <!-- CONVERT INPUT TO XML FOR JSON -->
        <xsl:variable name="xml">
            <array>
                <map>
                    <!-- <array key="trip">
                         <map>
                         <string key="name">
                         </string>
                         <string key="code">
                         </string>
                         <string key="planning_date">
                         </string>
                         <string key="created_from">
                         </string>
                         <string key="scheduled">
                         </string>
                         <string key="driver_id">
                         </string>
                         <string key="asset_id">
                         </string>
                         </map>
                         </array> -->
                    <array key="deliveries">
                        <xsl:choose>
                            <xsl:when test="(ns0:FromAddressNo != '') and (ns0:ToAddressNo != '')">
                                <xsl:call-template name="writeDeliveries">
                                    <xsl:with-param name="n">2</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="(ns0:FromAddressNo != '') and (ns0:ToAddressNo = '')">
                                <xsl:call-template name="writeDeliveries">
                                    <xsl:with-param name="n">1</xsl:with-param>
                                    <xsl:with-param name="type">from</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="(ns0:FromAddressNo = '') and (ns0:ToAddressNo != '')">
                                <xsl:call-template name="writeDeliveries">
                                    <xsl:with-param name="n">1</xsl:with-param>
                                    <xsl:with-param name="type">to</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="(count(ns0:FromAddressNo) &gt; 0) and (count(ns0:ToAddressNo) = 0)">
                                <xsl:call-template name="writeDeliveries">
                                    <xsl:with-param name="n">1</xsl:with-param>
                                    <xsl:with-param name="type">from</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="(count(ns0:FromAddressNo) = 0) and (count(ns0:ToAddressNo) &gt; 0)">
                                <xsl:call-template name="writeDeliveries">
                                    <xsl:with-param name="n">1</xsl:with-param>
                                    <xsl:with-param name="type">to</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </array>
                </map>
            </array>
        </xsl:variable>
        
        <!-- OUTPUT -->
        <xsl:value-of select="xml-to-json($xml)"/>
    </xsl:template>
    
    <xsl:template name="writeDeliveries">
        <xsl:param name="n"></xsl:param>
        <xsl:param name="type"></xsl:param>
        <xsl:choose>
            <xsl:when test="$n &gt; 0">
                <xsl:choose>
                    <xsl:when test="$type = ''">
                        <xsl:call-template name="writeDelivery">
                            <xsl:with-param name="type">from</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="writeDelivery">
                            <xsl:with-param name="type">to</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="writeDelivery">
                            <xsl:with-param name="type">
                                <xsl:value-of select="$type"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="writeDelivery">
        <xsl:param name="type"></xsl:param>
        <xsl:variable name="newline">
            <xsl:text>&#xa;</xsl:text>
        </xsl:variable>
        
        <map>
            <string key="handle">
                <xsl:choose>
                    <xsl:when test="$type = 'from'">
                        <xsl:text>pickup</xsl:text>
                    </xsl:when>
                    <xsl:when test="$type = 'to'">
                        <xsl:text>drop</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </string>
            <!-- <string key="created_from">
                 </string> -->
            <xsl:choose>
                <xsl:when test="$type = 'from'">
                    <xsl:if test="((count(//ns0:Comments/ns0:Comment) + count(//ns0:LoadComment)) &gt; 0) or (ns0:LoadReference != '')">
                        <string key="comment">
                            <xsl:if test="ns0:LoadReference != ''">
                                <xsl:value-of select="concat(ns0:LoadReference, $newline)"/>
                            </xsl:if>

                            <xsl:for-each select="//ns0:Comments/ns0:Comment">
                                <xsl:value-of select="concat(ns0:Comment, $newline)"/>
                            </xsl:for-each>
                            
                            <xsl:for-each select="//ns0:LoadComment">
                                <xsl:value-of select="concat(ns0:Comment, $newline)"/>
                            </xsl:for-each>
                        </string>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$type = 'to'">
                    <xsl:if test="((count(//ns0:Comments/ns0:Comment) + count(//ns0:UnloadComment)) &gt; 0) or (ns0:UnloadReference != '')">
                        <string key="comment">
                            <xsl:if test="ns0:UnloadReference != ''">
                                <xsl:value-of select="concat(ns0:UnloadReference, $newline)"/>
                            </xsl:if>

                            <xsl:for-each select="//ns0:Comments/ns0:Comment">
                                <xsl:value-of select="concat(ns0:Comment, $newline)"/>
                            </xsl:for-each>
                            
                            <xsl:for-each select="//ns0:UnloadComment">
                                <xsl:value-of select="concat(ns0:Comment, $newline)"/>
                            </xsl:for-each>
                        </string>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            
            <string key="tracking_number">
                <xsl:value-of select="ns0:No"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="ns0:SequenceNo"/>
                <xsl:choose>
                    <xsl:when test="$type = 'from'">
                        <xsl:text>-P</xsl:text>
                    </xsl:when>
                    <xsl:when test="$type = 'to'">
                        <xsl:text>-D</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </string>
            <xsl:if test="ns0:ParentDocumentNo != ''">
                <string key="reference">
                    <xsl:value-of select="ns0:ParentDocumentNo"/>
                </string>
            </xsl:if>
            <!-- <number key="service_time">
                 <xsl:number value="1"/>
                 </number>
                 <number key="stop_index">
                 <xsl:number value="1"/>
                 </number> -->
            <array key="due_dates">
                <map>
                    <xsl:choose>
                        <xsl:when test="$type = 'from'">
                            <string key="start">
                                <xsl:choose>
                                    <xsl:when test="ns0:LoadingDateFrom != ''">
                                        <xsl:value-of select="format-date(ns0:LoadingDateFrom, '[Y0001]-[M01]-[D01]')"/>
                                        <xsl:text>T</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="ns0:LoadingTimeFrom = '00:00:00'">
                                                <xsl:text>02:00:00</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-time(ns0:LoadingTimeFrom, '[H01]:[m01]:[s01]')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="format-date(ns0:UnloadingDateFrom, '[Y0001]-[M01]-[D01]')"/>
                                        <xsl:text>T</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="ns0:UnloadingTimeFrom = '00:00:00'">
                                                <xsl:text>02:00:00</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-time(ns0:UnloadingTimeFrom, '[H01]:[m01]:[s01]')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </string>
                            <string key="end">
                                <xsl:choose>
                                    <xsl:when test="ns0:LoadingDateTo != ''">
                                        <xsl:value-of select="format-date(ns0:LoadingDateTo, '[Y0001]-[M01]-[D01]')"/>
                                        <xsl:text>T</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="ns0:LoadingTimeTo = '00:00:00' or ns0:LoadingTimeTo = '23:59:59'">
                                                <xsl:text>23:55:00</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-time(ns0:LoadingTimeTo, '[H01]:[m01]:[s01]')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="format-date(ns0:UnloadingDateTo, '[Y0001]-[M01]-[D01]')"/>
                                        <xsl:text>T</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="ns0:UnloadingTimeTo = '00:00:00' or ns0:UnloadingTimeTo = '23:59:59'">
                                                <xsl:text>23:55:00</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-time(ns0:UnloadingTimeTo, '[H01]:[m01]:[s01]')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </string>
                        </xsl:when>
                        <xsl:when test="$type = 'to'">
                            <string key="start">
                                <xsl:choose>
                                    <xsl:when test="ns0:UnloadingDateFrom != ''">
                                        <xsl:value-of select="format-date(ns0:UnloadingDateFrom, '[Y0001]-[M01]-[D01]')"/>
                                        <xsl:text>T</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="ns0:UnloadingTimeFrom = '00:00:00'">
                                                <xsl:text>02:00:00</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-time(ns0:UnloadingTimeFrom, '[H01]:[m01]:[s01]')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="format-date(ns0:LoadingDateFrom, '[Y0001]-[M01]-[D01]')"/>
                                        <xsl:text>T</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="ns0:LoadingTimeFrom = '00:00:00'">
                                                <xsl:text>02:00:00</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-time(ns0:LoadingTimeFrom, '[H01]:[m01]:[s01]')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </string>
                            <string key="end">
                                <xsl:choose>
                                    <xsl:when test="ns0:UnloadingDateTo != ''">
                                        <xsl:value-of select="format-date(ns0:UnloadingDateTo, '[Y0001]-[M01]-[D01]')"/>
                                        <xsl:text>T</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="ns0:UnloadingTimeTo = '00:00:00' or ns0:UnloadingTimeTo = '23:59:59'">
                                                <xsl:text>23:55:00</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-time(ns0:UnloadingTimeTo, '[H01]:[m01]:[s01]')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="format-date(ns0:LoadingDateTo, '[Y0001]-[M01]-[D01]')"/>
                                        <xsl:text>T</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="ns0:LoadingTimeTo = '00:00:00' or ns0:LoadingTimeTo = '23:59:59'">
                                                <xsl:text>23:55:00</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-time(ns0:LoadingTimeTo, '[H01]:[m01]:[s01]')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </string>
                        </xsl:when>
                    </xsl:choose>
                </map>
            </array>
            <array key="items">
                <xsl:for-each select="ns0:DocumentLines/ns0:DocumentLine">
                    <map>
                        <string key="billing_id">
                            <xsl:value-of select="../../ns0:DroponCustomerNo"/>
                        </string>
                        <number key="count">
                            <xsl:number value="ns0:Quantity"/>
                        </number>
                        <string key="name">
                            <xsl:value-of select="ns0:No"/>
                        </string>
                        <!-- <string key="number">
                             </string>
                             <array key="capacity">
                             </array> -->
                        <array key="tags">
                            <xsl:if test="../../ns0:Attribute01 != ''">
                                <string>
                                    <xsl:value-of select="../../ns0:Attribute01"/>
                                </string>
                            </xsl:if>
                        </array>
                    </map>
                </xsl:for-each>
            </array>
            <map key="recipient">
                <xsl:choose>
                    <xsl:when test="$type = 'from'">
                        <string key="name">
                            <xsl:value-of select="ns0:FromAddressDescription"/>
                        </string>
                        <string key="street">
                            <xsl:value-of select="ns0:FromAddressStreet"/>
                        </string>
                        <!-- <string key="nr">
                             </string> -->
                        <!-- <string key="bus">
                             </string> -->
                        <string key="city">
                            <xsl:value-of select="ns0:FromAddressCity"/>
                        </string>
                        <string key="zip">
                            <xsl:value-of select="ns0:FromAddressPostCode"/>
                        </string>
                        <string key="country">
                            <xsl:value-of select="ns0:FromAddressCountryCode"/>
                        </string>
                        <!-- <string key="phone">
                             </string>
                             <string key="phone_extra">
                             </string>
                             <string key="email">
                             </string>
                             <string key="company">
                             </string>
                             <string key="locale">
                             </string>
                             <array key="coordinates">
                             </array> -->
                     </xsl:when>
                    <xsl:when test="$type = 'to'">
                        <string key="name">
                            <xsl:value-of select="ns0:ToAddressDescription"/>
                        </string>
                        <string key="street">
                            <xsl:value-of select="ns0:ToAddressStreet"/>
                        </string>
                        <!-- <string key="nr">
                             </string> -->
                        <!-- <string key="bus">
                             </string> -->
                        <string key="city">
                            <xsl:value-of select="ns0:ToAddressCity"/>
                        </string>
                        <string key="zip">
                            <xsl:value-of select="ns0:ToAddressPostCode"/>
                        </string>
                        <string key="country">
                            <xsl:value-of select="ns0:ToAddressCountryCode"/>
                        </string>
                        <!-- <string key="phone">
                             </string>
                             <string key="phone_extra">
                             </string>
                             <string key="email">
                             </string>
                             <string key="company">
                             </string>
                             <string key="locale">
                             </string>
                             <array key="coordinates">
                             </array> -->
                     </xsl:when>
                </xsl:choose>
            </map>
        </map>
    </xsl:template>
    
</xsl:stylesheet>