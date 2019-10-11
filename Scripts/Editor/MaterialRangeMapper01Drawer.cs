// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MaterialRangeMapper01Drawer.cs" company="Supyrb">
//   Copyright (c) 2019 Supyrb. All rights reserved.
// </copyright>
// <author>
//   Johannes Deml
//   public@deml.io
// </author>
// --------------------------------------------------------------------------------------------------------------------

using System;
using UnityEditor;
using UnityEngine;

namespace Supyrb
{
	public class MaterialRangeMapper01Drawer : MaterialPropertyDrawer
	{
		private GUIContent guiContent;
		private const string tooltip = "x:Lower Input, y:Upper Input";
		private const float labelWidth = 100f;

		public MaterialRangeMapper01Drawer()
		{
			guiContent = new GUIContent(string.Empty, tooltip);
		}

		public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
		{
			var previousLabelWidth = EditorGUIUtility.labelWidth;
			EditorGUIUtility.labelWidth = labelWidth;
			
			guiContent.text = label;
			var value = prop.vectorValue;
			var minValue = value.x;
			var maxValue = value.y;

			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;
			
			EditorGUI.MinMaxSlider(position, guiContent, ref minValue, ref maxValue, 0f, 1f);

			EditorGUI.showMixedValue = false;

			if (EditorGUI.EndChangeCheck())
			{
				value.x = minValue;
				value.y = maxValue;
				prop.vectorValue = value;
			}

			EditorGUIUtility.labelWidth = previousLabelWidth;
		}
	}
}