// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MaterialEightBitDrawer.cs" company="Supyrb">
//   Copyright (c) 2019 Supyrb. All rights reserved.
// </copyright>
// <author>
//   Johannes Deml
//   send@johannesdeml.com
// </author>
// --------------------------------------------------------------------------------------------------------------------

using System;
using UnityEditor;
using UnityEngine;

namespace Supyrb
{
	/// <summary>
	/// Material PropertyDrawer [EightBit] makes sure that the value can only be an int between 0 and 255
	/// </summary>
	public class MaterialEightBitDrawer : MaterialPropertyDrawer
	{
		private GUIContent guiContent;
		private const string tooltip = "Value between 0 and 255";

		public MaterialEightBitDrawer()
		{
			this.guiContent = new GUIContent(string.Empty, tooltip);
		}

		public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
		{
			guiContent.text = label;
			var value = prop.floatValue;
			var intValue = (int) value;

			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;

			intValue = EditorGUI.IntField(position, guiContent, intValue);
			intValue = Mathf.Clamp(intValue, 0, 255);
			value = (float) intValue;

			EditorGUI.showMixedValue = false;
			if (EditorGUI.EndChangeCheck())
			{
				prop.floatValue = value;
			}
		}
	}
}