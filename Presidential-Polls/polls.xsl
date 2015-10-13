<?xml version="1.0" encoding="UTF-8" ?>
<!--
   New Perspectives on XML
   Tutorial 7
   Case Problem 1

   Election Results XSLT Style Sheet
   Author: Kristopher Rutherford
   Date:   11/18/2012

   Filename:         polls.xsl
   Supporting Files: back.jpg, logo.jpg, polls.css
-->

<xsl:stylesheet version='1.0' xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="html" version="4.0" />

   <xsl:decimal-format name="votes-number"/>
   <xsl:decimal-format name="votes-percentage"/>

   <xsl:variable name="bluecell">
      <td class="blue"> </td>
   </xsl:variable>
   <xsl:variable name="redcell">
      <td class="red"> </td>
   </xsl:variable>
   <xsl:variable name="greencell">
      <td class="green"> </td>
   </xsl:variable>

   <xsl:template match="/">
      <html>
         <head>
            <title>Election Night Results</title>
            <link href="polls.css" rel="stylesheet" type="text/css" />
         </head>
         <body>
            <div id="intro">
               <p>
                  <img src="logo.jpg" alt="Election Day Results" />
               </p>
               <a href="#">Election Home Page</a>
               <a href="#">President</a>
               <a href="#">Senate Races</a>
               <a href="#">Congressional Races</a>
               <a href="#">State Senate</a>
               <a href="#">State House</a>
               <a href="#">Local Races</a>
               <a href="#">Judicial</a>
               <a href="#">Referendums</a>
            </div>

            <div id="results">
               <h1>Congressional Races</h1>
               <xsl:apply-templates select="polls/race" />
            </div>
         </body>
      </html>
   </xsl:template>

   <xsl:template match="race">
      <xsl:variable name="votesTotal" select="sum(candidate/votes)"/>
      
      <h2>
         <xsl:value-of select="title" />
      </h2>
      <table cellpadding="1" cellspacing="1">
         <tr>
            <th>Candidate</th>
            <th class="num">Votes</th>
            <th class="showBar" colspan="100"></th>
         </tr>
         <xsl:apply-templates select="candidate" >
            <xsl:with-param name="votesTotal" select="$votesTotal"/>
         </xsl:apply-templates>
      </table>
   </xsl:template>

   <xsl:template match="candidate">
      <xsl:param name="votesTotal" select="0" />
      <xsl:variable name="ratio" select="votes div $votesTotal"/>
      <tr>
         <td class="name">
            <xsl:value-of select="name" /> 
            <xsl:text> (</xsl:text>
            <xsl:value-of select="party" />
            <xsl:text>)</xsl:text>
         </td>
         <td class="num">
            <xsl:value-of select="format-number(votes, '#,###', 'votes-number')" />
            <xsl:text> (</xsl:text>
            <xsl:value-of select="format-number($ratio, '#0%', 'votes-percentage')" />
            <xsl:text>)</xsl:text>
         </td>
         <xsl:call-template name="showBar">
            <xsl:with-param name="cells" select="floor($ratio * 100)" />
            <xsl:with-param name="partyType" select="party" />
         </xsl:call-template>
      </tr>
   </xsl:template>

   <xsl:template name="showBar">
      <xsl:param name="cells" select="0" />
      <xsl:param name="partyType" />
      <xsl:if test="$cells > 0">
         <xsl:choose>
            <xsl:when test="$partyType = 'D'">
               <xsl:copy-of select="$bluecell"/>
            </xsl:when>
            <xsl:when test="$partyType = 'R'">
               <xsl:copy-of select="$redcell"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="$greencell"/>
            </xsl:otherwise>
         </xsl:choose>
         
         <xsl:call-template name="showBar">
            <xsl:with-param name="cells" select="$cells - 1" />
            <xsl:with-param name="partyType" select="$partyType" />
         </xsl:call-template>
      </xsl:if>      
   </xsl:template>

</xsl:stylesheet>