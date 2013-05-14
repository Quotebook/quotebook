<?php
/**
 * @package kickir.com
 * @subpackage json
 *
 *
 * NOTICE:  Written by Kickir, LLC
 *
 *
 * Copyright 2013 Kickir LLC
 *
 *  Licensed as per Kickir LLC Services Agreement;
 *  you may not use this file except in compliance with the Kickir Services Agreement.
 *  You may obtain a copy of the Services Agreement from Kickir LLC upon request.
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the Services Agreement for the specific language governing permissions and
 *  limitations under the Services Agreement.
 *
 */
?>

<!--  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>  -->
<script type="text/javascript" src="<?php echo Config::$base_url; ?>/includes/jquery-1.7.2.js"></script>

<script type="text/javascript">

$.fn.serializeObject = function()
{
	var c = {}
	var o = {};
	var a = this.serializeArray();
	$.each(a, function() {
		if (this.name == 'commandName') {
			c['commandName'] = this.value || '';
		}
		else {
    		if (o[this.name] !== undefined) {
    				
    			if (!o[this.name].push) {
    				o[this.name] = [o[this.name]];
    			}
    			o[this.name].push(this.value || '');
    		}
    		else {
    			o[this.name] = this.value || '';
    		}
		}
   });

   c['data'] = o;
	return c;
};

$(function() {	
    $('.submit_json').click(function() {
        var form = $(this).parent('form');
        document.getElementById('json_text').value = JSON.stringify(form.serializeObject()); 
        document.getElementById('form_json').submit();
    });
});
</script>